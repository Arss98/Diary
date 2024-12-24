import Foundation

enum ScreenModeTask {
    case add
    case edit
}

final class AddTaskPresenter: AddTaskPresenterProtocol {
    weak var view: AddTaskViewProtocol?
    
    private let interactor: AddTaskInteractorProtocol
    private let router: AddTaskRouterProtocol
    private let task: TaskDomain?
    private let date: Date?
    private let screenMode: ScreenModeTask
    
    init(interactor: AddTaskInteractorProtocol, router: AddTaskRouterProtocol, task: TaskDomain? = nil, date: Date? = nil, screenMode: ScreenModeTask) {
        self.interactor = interactor
        self.router = router
        self.task = task
        self.date = date
        self.screenMode = screenMode
    }
}

// MARK: - AddTaskPresenterProtocol
extension AddTaskPresenter {
    func determineScreenMode() {
        switch screenMode {
        case .add:
            self.view?.setupNavigationBar(title: Consts.Headers.addTaskTitle, showDeleteButton: false)
            
            if let date = date {
                self.view?.setupDate(date: date)
            }
        case .edit:
            self.view?.setupNavigationBar(title: Consts.Headers.editTaskTitle, showDeleteButton: true)
            
            if let task = task {
                self.view?.setupUIData(task: task)
                self.view?.setupDate(date: task.dateStart)
            }
        }
    }
    
    func validateInput(title: String?, description: String?) -> Bool {
        guard let title = title, !title.isEmpty,
              let description = description, !description.isEmpty else {
            view?.showError(message: "Title and description cannot be empty!")
            return false
        }
        return true
    }
    
    func saveTask(title: String?, description: String?, dateStart: Date, dateFinish: Date) {
        guard validateInput(title: title, description: description),
              let validTitle = title,
              let validDescription = description else { return }
        
        do {
            switch screenMode {
            case .add:
                let task = TaskDomain(title: validTitle, descriptionTask: validDescription, dateStart: dateStart, dateFinish: dateFinish)
                try interactor.saveTask(task: task)
            case .edit:
                guard let taskId = task?.id else { return }
                let task = TaskDomain(id: taskId, title: validTitle, descriptionTask: validDescription, dateStart: dateStart, dateFinish: dateFinish)
                try interactor.updateTask(task: task)
            }
            self.router.goBack()
        } catch {
            view?.showError(message: "Failed to save task: \(error.localizedDescription)")
        }
    }
    
    func deleteTask() {
        guard let taskId = self.task?.id else { return }
        
        do {
            try interactor.deleteTask(by: taskId)
            self.router.popToRoot()
        } catch {
            view?.showError(message: "Failed to delete task: \(error.localizedDescription)")
        }
    }
}

import Foundation

final class DetailTaskPresenter: DetailTaskPresenterProtocol {
    weak var view: DetailTaskViewProtocol?
    
    private var currentTask: TaskDomain?
    private let interactor: DetailTaskInteractorProtocol
    private let router: DetailTaskRouterProtocol
    
    init(interactor: DetailTaskInteractorProtocol, router: DetailTaskRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Pressenter Func
extension DetailTaskPresenter {
    func loadTask() {
        switch interactor.fetchTask() {
        case .success(let task):
            self.handleTaskFetchSuccess(task)
        case .failure:
            self.view?.displayError(message: Consts.ErrorMessages.generalErrorMessage)
        }
    }
    
    func editTaskButtonTapped() {
        guard let task = currentTask else {
            view?.displayError(message: Consts.ErrorMessages.taskDataNotAvailableMessage)
            return
        }
        
        router.navigateToEditTask(task: task)
    }
    
    private func handleTaskFetchSuccess(_ task: TaskDomain?) {
        guard let task = task else {
            view?.displayError(message: Consts.ErrorMessages.taskNotFoundMessage)
            return
        }
        
        currentTask = task
        let timeInterval = interactor.formatDateToString(from: task.dateStart, to: task.dateFinish)
        view?.displayTask(title: task.title, description: task.descriptionTask, timeInterval: timeInterval)
    }
}

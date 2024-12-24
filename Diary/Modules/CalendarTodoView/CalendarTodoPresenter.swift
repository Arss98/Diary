import Foundation

final class CalendarTodoPresenter: CalendarTodoPresenterProtocol {
    weak var view: CalendarTodoViewProtocol?
    
    private(set) var sections: [Section] = []
    private var tasks: [TaskDomain] = []
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter
    }()
    
    private let interactor: CalendarTodoInteractorProtocol
    private let router: CalendarTodoRouterProtocol
    
    init(interactor: CalendarTodoInteractorProtocol, router: CalendarTodoRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - CalendarTodoPresenterProtocol
extension CalendarTodoPresenter {
    func fetchTasks(for date: Date) {
        interactor.fetchTasks(for: date)
    }
    
    func didFetchTasks(tasks: [TaskDomain]) {
        guard let view = self.view else { return }
        
        self.tasks = tasks
        self.sections = createSections(from: tasks)
        view.updateSections()
    }
    
    func deleteTask(at index: Int) {
        do {
            try interactor.deleteTask(at: index)
            tasks.remove(at: index)
            
            self.sections = createSections(from: tasks)
        } catch {
            self.view?.showError(message: "Unable to delete task.")
        }
    }
    
    func getCurrentDateString() -> String {
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: Date())
    }
    
    func hasTasks(for date: Date) -> Bool {
        self.interactor.checkTaskAvailability(for: date)
    }
    
    func tableCellTapped(at indexPath: IndexPath) {
        guard indexPath.section < sections.count,
              indexPath.row < sections[indexPath.section].tasks.count else { return }
        
        guard let taskID = sections[indexPath.section].tasks[indexPath.row].id else { return }
        
        self.router.goToDetail(with: taskID)
    }
    
    func addButtonTapped(for date: Date) {
        self.router.goToAdd(for: date)
    }
    
    private func createSections(from taskList: [TaskDomain]) -> [Section] {
        var sections = (0...23).map { hour -> Section in
            let hourString = String(format: "%02d:00", hour % 24)
            return Section(hour: hourString, tasks: [])
        }
        
        let calendar = Calendar.current
        for task in taskList {
            let hour = calendar.component(.hour, from: task.dateStart)
            if hour < sections.count {
                sections[hour].tasks.append(task)
            }
        }
        return sections
    }
}

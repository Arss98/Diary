import Foundation

final class CalendarTodoInteractor: CalendarTodoInteractorProtocol {
    weak var presenter: CalendarTodoPresenterProtocol?
    
    private(set) var taskList: [TaskDomain] = []
    private let repository: RepositoryProtocol

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: - CalendarTodoInteractorProtocol
extension CalendarTodoInteractor {
    func fetchTasks(for date: Date) {
        taskList = TaskModelMapper.matToDomainList(from: repository.fetchAll(forDate: date))
        
        presenter?.didFetchTasks(tasks: taskList)
    }
    
    func checkTaskAvailability(for date: Date) -> Bool {
        let tasks = repository.fetchAll(forDate: date)
        
        return !tasks.isEmpty
    }
    
    func deleteTask(at index: Int) throws {
        guard let taskId = taskList[index].id else { return }
        
        try repository.delete(by: taskId)
        taskList.remove(at: index)
    }
}

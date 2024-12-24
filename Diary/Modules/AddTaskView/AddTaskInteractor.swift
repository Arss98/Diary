import Foundation

final class AddTaskInteractor: AddTaskInteractorProtocol {
    weak var presenter: AddTaskPresenterProtocol?
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: - AddTaskInteractorProtocol
extension AddTaskInteractor {
    func saveTask(task: TaskDomain) throws {
        let taskEntity = TaskModelMapper.mapToEntity(from: task)
        try repository.save(task: taskEntity)
    }
    
    func deleteTask(by id: String) throws {
        try repository.delete(by: id)
    }
    
    func updateTask(task: TaskDomain) throws {
        let taskEntity = TaskModelMapper.mapToEntity(from: task)
        try repository.update(task: taskEntity)
    }
}

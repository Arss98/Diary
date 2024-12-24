import Foundation

final class DetailTaskInteractor: DetailTaskInteractorProtocol {
    weak var presenter: DetailTaskPresenterProtocol?
    
    private let id: String
    private let repository: RepositoryProtocol
    
    private let dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyyy"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    init(id: String, repository: RepositoryProtocol) {
        self.id = id
        self.repository = repository
    }
}

// MARK: - DetailTaskInteractorProtocol
extension DetailTaskInteractor {
    func fetchTask() -> Result<TaskDomain?, Error> {
        do {
            let task = TaskModelMapper.matToDomain(from: try repository.fetchTask(by: id))
            return .success(task)
        } catch {
            return .failure(error)
        }
    }
    
    func formatDateToString(from startTime: Date, to endTime: Date) -> String {
        let dayOfWeekString = dayOfWeekFormatter.string(from: startTime)
        let start = timeFormatter.string(from: startTime)
        let end = timeFormatter.string(from: endTime)
        
        return "\(dayOfWeekString)\nfrom \(start) to \(end)"
    }
}

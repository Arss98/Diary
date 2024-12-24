import Foundation

final class CalendarTodoRouter: CalendarTodoRouterProtocol {
    weak var view: CalendarTodoViewController?
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func goToAdd(for date: Date) {
        let addView = AddTaskModuleBuilder.build(repository: repository, date: date)
        
        guard let view = view else { return }
        view.navigationController?.pushViewController(addView, animated: true)
    }
    
    func goToDetail(with id: String) {
        let detailView = DetailTaskModuleBuilder.build(id: id, repository: repository)
        
        guard let view = view else { return }
        view.navigationController?.pushViewController(detailView, animated: true)
    }
}

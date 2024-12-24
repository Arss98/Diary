import Foundation
import UIKit

final class DetailTaskRouter: DetailTaskRouterProtocol {
    weak var view: DetailTaskViewController?
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func navigateToEditTask(task: TaskDomain) {
        let addTaskView = AddTaskModuleBuilder.build(repository: repository, task: task, screenMode: .edit)
        
        guard let view = view else { return }
        view.navigationController?.pushViewController(addTaskView, animated: true)
    }
}

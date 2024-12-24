import UIKit

final class AddTaskModuleBuilder {
    static func build(repository: RepositoryProtocol, task: TaskDomain? = nil, date: Date? = nil, screenMode: ScreenModeTask = .add) -> UIViewController {
        let interactor = AddTaskInteractor(repository: repository)
        let router = AddTaskRouter()
        let presenter = AddTaskPresenter(interactor: interactor, router: router, task: task, date: date, screenMode: screenMode)
        let viewController = AddTaskViewController()
    
        viewController.presenter = presenter
        presenter.view = viewController
        router.view = viewController
        interactor.presenter = presenter
        
        return viewController
    }
}

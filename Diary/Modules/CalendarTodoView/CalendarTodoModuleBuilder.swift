import UIKit

final class CalendarTodoModuleBuilder {
    func build(repository: RepositoryProtocol) -> UIViewController {
        let interactor = CalendarTodoInteractor(repository: repository)
        let router = CalendarTodoRouter(repository: repository)
        let presenter = CalendarTodoPresenter(interactor: interactor, router: router)
        let viewController = CalendarTodoViewController()
        
        viewController.presenter = presenter
        presenter.view = viewController
        router.view = viewController
        interactor.presenter = presenter
        
        return viewController
    }
}

import UIKit

final class DetailTaskModuleBuilder {
    static func build(id: String, repository: RepositoryProtocol) -> UIViewController {
        let interactor = DetailTaskInteractor(id: id, repository: repository)
        let router = DetailTaskRouter(repository: repository)
        let presenter = DetailTaskPresenter(interactor: interactor, router: router)
        let viewController = DetailTaskViewController()
        
        viewController.presenter = presenter
        router.view = viewController
        presenter.view = viewController
        interactor.presenter = presenter
        
        return viewController
    }
}

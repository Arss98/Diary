import Foundation

final class AddTaskRouter: AddTaskRouterProtocol {
    weak var view: AddTaskViewController?
    
    func goBack() {
        self.view?.navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        self.view?.navigationController?.popToRootViewController(animated: true)
    }
}

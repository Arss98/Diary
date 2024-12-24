import Foundation

protocol AddTaskViewProtocol: AnyObject {
    var presenter: AddTaskPresenterProtocol? { get set }
    
    func setupUIData(task: TaskDomain)
    func setupDate(date: Date)
    func setupNavigationBar(title: String, showDeleteButton: Bool)
    func showError(message: String)
}

protocol AddTaskPresenterProtocol: AnyObject {
    var view: AddTaskViewProtocol? { get set }
    
    func determineScreenMode()
    func validateInput(title: String?, description: String?) -> Bool
    func saveTask(title: String?, description: String?, dateStart: Date, dateFinish: Date)
    func deleteTask()
}

protocol AddTaskInteractorProtocol: AnyObject {
    var presenter: AddTaskPresenterProtocol? { get set }
    
    func saveTask(task: TaskDomain) throws
    func deleteTask(by id: String) throws
    func updateTask(task: TaskDomain) throws
}

protocol AddTaskRouterProtocol: AnyObject {
    var view: AddTaskViewController? { get set }
    
    func goBack()
    func popToRoot()
}

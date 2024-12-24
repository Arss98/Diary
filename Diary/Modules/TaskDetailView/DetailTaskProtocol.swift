import Foundation

protocol DetailTaskViewProtocol: AnyObject {
    var presenter: DetailTaskPresenterProtocol? { get set }
    
    func displayTask(title: String, description: String, timeInterval: String)
    func displayError(message: String)
}

protocol DetailTaskPresenterProtocol: AnyObject {
    var view: DetailTaskViewProtocol? { get set }
    
    func loadTask()
    func editTaskButtonTapped()
}

protocol DetailTaskInteractorProtocol: AnyObject {
    var presenter: DetailTaskPresenterProtocol? { get set }
    
    func fetchTask() -> Result<TaskDomain?, Error>
    func formatDateToString(from startTime: Date, to endTime: Date) -> String
}

protocol DetailTaskRouterProtocol: AnyObject {
    var view: DetailTaskViewController? { get set }
    
    func navigateToEditTask(task: TaskDomain)
}

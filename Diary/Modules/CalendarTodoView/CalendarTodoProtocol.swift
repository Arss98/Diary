import Foundation

protocol CalendarTodoViewProtocol: AnyObject {
    var presenter: CalendarTodoPresenterProtocol? { get set }
    
    func showError(message: String)
    func updateSections()
}

protocol CalendarTodoPresenterProtocol: AnyObject {
    var view: CalendarTodoViewProtocol? { get set }
    var sections: [Section] { get }
    
    func fetchTasks(for date: Date)
    func deleteTask(at index: Int)
    func getCurrentDateString() -> String
    func hasTasks(for date: Date) -> Bool
    func didFetchTasks(tasks: [TaskDomain])
    func tableCellTapped(at indexPath: IndexPath)
    func addButtonTapped(for date: Date)
}

protocol CalendarTodoInteractorProtocol: AnyObject {
    var presenter: CalendarTodoPresenterProtocol? { get set }
    
    func fetchTasks(for date: Date)
    func checkTaskAvailability(for date: Date) -> Bool
    func deleteTask(at index: Int) throws
}

protocol CalendarTodoRouterProtocol: AnyObject {
    var view: CalendarTodoViewController? { get set }
    
    func goToAdd(for date: Date)
    func goToDetail(with id: String)
}

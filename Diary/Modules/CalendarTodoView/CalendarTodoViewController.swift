import UIKit
import FSCalendar
import SnapKit

final class CalendarTodoViewController: UIViewController {
    var presenter: CalendarTodoPresenterProtocol?
    
    private let contentView = CalendarTodoView()
    private var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchTasks(for: selectedDate)
        contentView.calendar.reloadData()
    }
    
    func initialize() {
        view = contentView
        
        setupNaVigationBar()
        setupDelegate()
        swipeAction()
    }
    
    func setupDelegate() {
        contentView.calendar.delegate = self
        contentView.calendar.dataSource = self
        contentView.taskList.delegate = self
        contentView.taskList.dataSource = self
    }
}

// MARK: - CalendarTodoViewProtocol
extension CalendarTodoViewController: CalendarTodoViewProtocol {
    func updateSections() {
        contentView.taskList.reloadData()
    }
    
    func showError(message: String) {
        self.showErroeAlert(title: Consts.Alerts.alertErrorTitle, message: message)
    }
}

// MARK: - UI settings
private extension CalendarTodoViewController {
    func setupNaVigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)
        ]
        
        self.title = presenter?.getCurrentDateString()
        self.navigationItem.backButtonTitle = Consts.UIConstants.backButtonTitle
        
        navigationController?.navigationBar.tintColor = .white
        
        guard let image = UIImage.imagePlus else { return }
        let rightButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CalendarTodoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.sections[section].tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = Consts.UIConstants.customCompactCellIdentifier
        contentView.taskList.register(CustomTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CustomTableViewCell ?? CustomTableViewCell()
    
        guard let presenter = presenter else { return cell }
        let task = presenter.sections[indexPath.section].tasks[indexPath.row]
        
        cell.configure(from: task.dateStart.dateToString,
                       to: task.dateFinish.dateToString,
                       nameTask: task.title)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.presenter?.sections[section].hour
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
            contentView.calendar.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.tableCellTapped(at: indexPath)
    }
}

// MARK: - FSCalendarDelegate, FSCalendarDataSource
extension CalendarTodoViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        self.title = dateFormatter.string(from: currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if date != selectedDate {
            presenter?.fetchTasks(for: date)
            selectedDate = date
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        guard let event = presenter?.hasTasks(for: date) else { return 0 }
        
        return event ? 1 : 0
    }
}

// MARK: - Private Metods
private extension CalendarTodoViewController {
    func swipeAction() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        contentView.calendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        contentView.calendar.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        guard !(contentView.calendar.scope == .month && gesture.direction == .down) else { return }
        guard !(contentView.calendar.scope == .week && gesture.direction == .up) else { return }
        
        updateView()
    }
    
    func updateView() {
        let newCalendarHeight: CGFloat = contentView.calendar.frame.height == 240 ? 80 : 240
        let newTaskListOffset: CGFloat = contentView.calendar.frame.height == 240 ? 0 : 8
        
        self.contentView.calendar.scope = (self.contentView.calendar.scope == .month) ? .week : .month
        
        UIView.animate(withDuration: 0.3) {
            self.contentView.calendar.snp.updateConstraints { make in
                make.height.equalTo(newCalendarHeight)
            }
            
            self.contentView.tableHeaderLabel.snp.updateConstraints { make in
                make.top.equalTo(self.contentView.calendar.snp.bottom).offset(newTaskListOffset)
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func addButtonTapped() {
        presenter?.addButtonTapped(for: selectedDate)
    }
}

import UIKit
import FSCalendar
import SnapKit

enum TypeTaskList {
    case expand
    case compact
}

final class CalendarTodoViewController: UIViewController {
    private let viewModel = CalendarTodoViewModel()
    private let contentView = CalendarTodoView()
    private var selectedDate: Date = Date()
    private var typeList: TypeTaskList = .compact {
        didSet {
            contentView.taskList.reloadData()
            viewModel.loadTasks(forDate: selectedDate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadTasks(forDate: selectedDate)
        contentView.calendar.reloadData()
    }
    
    func initialize() {
        view = contentView
        
        setupNaVigationBar()
        setupDelegate()
        swipeAction()
        setupButton()
    }
    
    func setupDelegate() {
        contentView.calendar.delegate = self
        contentView.calendar.dataSource = self
        contentView.taskList.delegate = self
        contentView.taskList.dataSource = self
        viewModel.delegate = self
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
        
        self.title = viewModel.currentDate
        self.navigationItem.backButtonTitle = Consts.UIConstants.backButtonTitle
        
        navigationController?.navigationBar.tintColor = .white
        
        guard let image = UIImage.imagePlus else { return }
        let rightButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CalendarTodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeList == .expand ? 25 : (viewModel.taskList?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier: String
        let cell: UITableViewCell

        switch typeList {
        case .expand:
            reuseIdentifier = Consts.UIConstants.customExpandetCellIdentifier
            contentView.taskList.register(ExpandedCustomTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ExpandedCustomTableViewCell ?? ExpandedCustomTableViewCell()
            if let expandedCell = cell as? ExpandedCustomTableViewCell {
                viewModel.configureExpandetCell(expandedCell, indexPath: indexPath, date: selectedDate)
            }

        case .compact:
            reuseIdentifier = Consts.UIConstants.customCompactCellIdentifier
            contentView.taskList.register(CompactCustomTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CompactCustomTableViewCell ?? CompactCustomTableViewCell()
            if let compactCell = cell as? CompactCustomTableViewCell {
                viewModel.configureCompactCell(compactCell, indexPath: indexPath)
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return typeList == .compact ? true : false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && typeList == .compact {
            viewModel.deleteTask(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            contentView.calendar.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch typeList {
        case .compact:
            if let task = viewModel.taskList?[indexPath.row] {
                navigateToDetailViewController(with: task)
            }
        case .expand:
            if let task = viewModel.taskDictionary[indexPath.row] {
                navigateToDetailViewController(with: task)
            }
        }
        
    }
    
    func navigateToDetailViewController(with task: TaskModel) {
        let detailView = DetailTaskViewController(id: task.id)
        navigationController?.pushViewController(detailView, animated: true)
    }
}

// MARK: - CalendarTodoViewModelDelegate
extension CalendarTodoViewController: CalendarTodoViewModelDelegate {
    func didLoadTasks() {
        contentView.taskList.reloadData()
    }
    
    func didChangeItemCount(to count: Int) {
        if typeList == .compact {
            contentView.noTasksLabel.isHidden = (count == 0) ? false : true
        } else {
            contentView.noTasksLabel.isHidden = true
        }
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
            viewModel.loadTasks(forDate: date)
            selectedDate = date
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let event = viewModel.checkTaskOfDay(date: date)
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
    
    func setupButton() {
        contentView.tableHeaderButton.addTarget(self, action: #selector(toggleTypeList), for: .touchUpInside)
    }
    
    @objc func toggleTypeList() {
        contentView.expandetList.toggle()
        typeList = contentView.expandetList ? .expand : .compact
    }
    
    @objc func addButtonTapped() {
        let addTaskVC = AddTaskViewController(selectedDate: selectedDate)
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
}

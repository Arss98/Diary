import UIKit
import SnapKit

class CalendarTodoViewController: UIViewController {
    private let viewModel = CalendarTodoViewModel()
    
    private var calendar: CalendarView
    private let floatingButton = UIButton(type: .system)
    private let taskList: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return  table
    }()
    
    init() {
        self.calendar = CalendarView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

private extension CalendarTodoViewController {
    func initialize() {
        view.backgroundColor = .background
        
        self.taskList.dataSource = self
        self.taskList.delegate = self
        self.taskList.register(CustomTableViewCell.self, forCellReuseIdentifier: Consts.customCellIdentifier)
        
        setupCalendar()
        setupTaskList()
        setupFloatingButton()
    }
    
    func setupFloatingButton() {
        if let image = UIImage.imagePlus {
            floatingButton.setImage(image, for: .normal)
        }
        
        floatingButton.backgroundColor = .mainBackground
        floatingButton.tintColor = .white
        floatingButton.layer.cornerRadius = 28
        floatingButton.layer.masksToBounds = true
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        
        view.addSubview(floatingButton)
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.width.equalTo(56)
        }
    }
    
    func setupCalendar() {
        view.addSubview(calendar)
        calendar.calendarGestureCallback = { [weak self] in
            self?.updateView()
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            make.height.equalTo(280)
        }
    }
    
    func setupTaskList() {
        taskList.layer.cornerRadius = 20
        taskList.separatorStyle = .none
        taskList.tableHeaderView = TableHeaderView(frame: CGRect(x: .zero, y: .zero, width: self.view.frame.width, height: 60))
        
        view.addSubview(taskList)
        
        taskList.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CalendarTodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.taskGetCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.customCellIdentifier, 
                                                 for: indexPath) as! CustomTableViewCell
        
        viewModel.configureCell(cell, indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}

private extension CalendarTodoViewController {
    func updateView() {
        let newCalendarHeight: CGFloat = calendar.frame.height == 280 ? 130 : 280
        let newTaskListOffset: CGFloat = calendar.frame.height == 280 ? 0 : 8
        
        calendar.snp.updateConstraints { make in
            make.height.equalTo(newCalendarHeight)
        }
        taskList.snp.updateConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(newTaskListOffset)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func floatingButtonTapped() {
        print("Floating button tapped!")
    }
}

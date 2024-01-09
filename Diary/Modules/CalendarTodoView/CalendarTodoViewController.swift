import UIKit
import SnapKit

class CalendarTodoViewController: UIViewController {
    private let viewModel = CalendarTodoViewModel()
    
    private var calendar: CalendarView
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .automatic
    }
}

//MARK: - UI settings
private extension CalendarTodoViewController {
    func initialize() {
        view.backgroundColor = .background
        
        setupNaVigationBar()
        addSubview()
        setupTaskList()
        setupConstraints()
        handleCalendarGesture()
    }
    
    func setupNaVigationBar() {
        let leftButton = UIBarButtonItem(title: "2024", style: .plain, target: self, action: #selector(floatingButtonTapped))
        navigationItem.leftBarButtonItem = leftButton
        
        
        guard let image = UIImage.imagePlus else { return }
        let rightButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    func addSubview() {
        view.addSubview(calendar)
        view.addSubview(taskList)
    }
    
    func setupTaskList() {
        self.taskList.dataSource = self
        self.taskList.delegate = self
        self.taskList.register(CustomTableViewCell.self, forCellReuseIdentifier: Consts.customCellIdentifier)
        
        taskList.layer.cornerRadius = 20
        taskList.separatorStyle = .none
        taskList.tableHeaderView = TableHeaderView(frame: CGRect(x: .zero, y: .zero, width: self.view.frame.width, height: 60))
    }
    
    func setupConstraints() {
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            make.height.equalTo(280)
        }
        
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

// MARK: - Private Extension
private extension CalendarTodoViewController {
    func handleCalendarGesture() {
        calendar.calendarGestureCallback = { [weak self] in
            self?.updateView()
        }
    }
    
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
    
    @objc func addButtonTapped() {
        let addTaskVC = AddTaskViewController()
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
}

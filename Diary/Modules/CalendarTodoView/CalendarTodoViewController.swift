import UIKit
import SnapKit

class CalendarTodoViewController: UIViewController {
    
    private let calendar = CalendarView()
    private let floatingButton = UIButton(type: .system)
    
    
    private let taskList: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return  table
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    func setup() {
        view.backgroundColor = .background
        
        self.taskList.dataSource = self
        self.taskList.delegate = self
        self.taskList.register(CustomTableViewCell.self, forCellReuseIdentifier: Consts.customCellIdentifier)
        
        setupCalendar()
        setupTaskList()
        setupFloatingButton()
    }
}

private extension CalendarTodoViewController {
    func setupFloatingButton() {
        if let image = UIImage(named: "plus") {
            floatingButton.setImage(image, for: .normal)
        }
        
        floatingButton.backgroundColor = .background
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
    
    
    @objc func floatingButtonTapped() {
        print("Floating button tapped!")
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CalendarTodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.customCellIdentifier, for: indexPath) as! CustomTableViewCell
        
        cell.configure(from: "9.00", to: "10.00", nameTask: "Task")
        cell.selectionStyle = .none
        return cell
    }
}

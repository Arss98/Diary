import UIKit
import FSCalendar
import SnapKit

final class CalendarTodoView: UIView {
    lazy var calendar = FSCalendar()
    lazy var tableHeaderLabel = UIView()
    lazy var tableHeaderButton = UIButton(type: .system)
    lazy var taskList = UITableView(frame: .zero, style: .plain)
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CalendarTodoView {
    func initialize() {
        self.backgroundColor = .mainBackground
        
        addSubview()
        setupСalendar()
        setupTableHeader()
        setupTaskList()
        setupConstraints()
    }
    
    func addSubview() {
        [calendar, tableHeaderLabel, tableHeaderButton, taskList]
            .forEach { addSubview($0) }
    }
    
    func setupСalendar() {
        calendar.headerHeight = .zero
        calendar.appearance.titleFont = .systemFont(ofSize: 17)
        calendar.appearance.weekdayFont = .systemFont(ofSize: 17)
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .todaySelect
        calendar.appearance.todaySelectionColor = .white
        calendar.appearance.titleSelectionColor = .mainBackground
        calendar.appearance.selectionColor = .white
        calendar.appearance.eventDefaultColor = .white
        calendar.appearance.eventSelectionColor = .white
    }
    
    func setupTableHeader() {
        let label = UILabel()
        
        tableHeaderLabel.addSubview(label)
        tableHeaderLabel.addSubview(tableHeaderButton)
        
        tableHeaderLabel.layer.cornerRadius = 32
        tableHeaderLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tableHeaderLabel.backgroundColor = .white
        
        tableHeaderButton.tintColor = .black
        
        label.text = Consts.Headers.tableHeaderView
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .medium)
                
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(24)
        }
        
        tableHeaderButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setupTaskList() {
        taskList.separatorStyle = .none
    }
    
    func setupConstraints() {
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(240)
        }
        
        tableHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        taskList.snp.makeConstraints { make in
            make.top.equalTo(tableHeaderLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

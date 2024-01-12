//
//  CalendarTodoView.swift
//  Diary
//
//  Created by  Arsen Dadaev on 12.01.2024.
//

import UIKit
import FSCalendar
import SnapKit

final class CalendarTodoView: UIView {
    lazy var calendar = FSCalendar()
    lazy var noTasksLabel = UILabel()
    lazy var tableHeaderLabel = UILabel()
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
        setupNoTasksLabel()
        setupConstraints()
    }
    
    func addSubview() {
        self.addSubview(calendar)
        self.addSubview(tableHeaderLabel)
        self.addSubview(taskList)
        taskList.addSubview(noTasksLabel)
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
        calendar.appearance.titleSelectionColor = UIColor.mainBackground
        calendar.appearance.selectionColor = .white
    }
    
    func setupTableHeader() {
        tableHeaderLabel.text = Consts.tableHeaderView
        tableHeaderLabel.textAlignment = .left
        tableHeaderLabel.textColor = .black
        tableHeaderLabel.font = .systemFont(ofSize: 24, weight: .medium)
    }
    
    func setupTaskList() {
        taskList.layer.cornerRadius = 20
        taskList.separatorStyle = .none
        taskList.tableHeaderView = tableHeaderLabel
        taskList.register(CustomTableViewCell.self, forCellReuseIdentifier: Consts.customCellIdentifier)
    }
    
    func setupNoTasksLabel() {
        noTasksLabel.text = Consts.noTasksLAbel
        noTasksLabel.textAlignment = .center
        noTasksLabel.font = .systemFont(ofSize: 20, weight: .medium)
        noTasksLabel.isHidden = true
    }
    
    func setupConstraints() {
        calendar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(16)
            make.height.equalTo(280)
        }
        
        taskList.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        noTasksLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tableHeaderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
    }
}

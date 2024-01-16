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
    lazy var tableHeaderLabel = UIView()
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
        calendar.appearance.titleSelectionColor = .mainBackground
        calendar.appearance.selectionColor = .white
        calendar.appearance.eventDefaultColor = .white
        calendar.appearance.eventSelectionColor = .white
    }
    
    func setupTableHeader() {
        let label = UILabel()
        
        tableHeaderLabel.addSubview(label)
        tableHeaderLabel.layer.cornerRadius = 20
        tableHeaderLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tableHeaderLabel.backgroundColor = .white
        
        label.text = Consts.tableHeaderView
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .medium)
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setupTaskList() {
        taskList.separatorStyle = .none
        taskList.register(CustomTableViewCell.self, forCellReuseIdentifier: Consts.customCellIdentifier)

        noTasksLabel.text = Consts.noTasksLAbel
        noTasksLabel.textAlignment = .center
        noTasksLabel.font = .systemFont(ofSize: 20, weight: .medium)
        noTasksLabel.isHidden = true
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
        
        noTasksLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

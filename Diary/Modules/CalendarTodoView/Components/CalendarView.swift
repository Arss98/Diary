//
//  CalendarView.swift
//  Diary
//
//  Created by  Arsen Dadaev on 27.12.2023.
//

import UIKit
import FSCalendar
import SnapKit

final class CalendarView: UIView {
    var calendarGestureCallback: (() -> Void)?
    
    private let viewModel: CalendarTodoViewModel
    private let calendar = FSCalendar()
    private let customCalendarHeader = UILabel()
    
    init(frame: CGRect, viewModel: CalendarTodoViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - FSCalendarDelegate, FSCalendarDataSource
extension CalendarView: FSCalendarDelegate, FSCalendarDataSource {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        customCalendarHeader.text = dateFormatter.string(from: currentPage)
    }
    
    private func getCurrentDate() -> String {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "MMMM yyyy"
        return dateFormator.string(from: Date())
    }
}

//MARK: - CalendarView UI Setting
private extension CalendarView {
    func initialize() {
        calendar.delegate = self
        calendar.dataSource = self
        
        setupCustomCalendarHeader()
        setupСalendar()
        swipeAction()
    }
    
    func setupCustomCalendarHeader() {
        customCalendarHeader.textAlignment = .left
        customCalendarHeader.textColor = .white
        customCalendarHeader.font = .systemFont(ofSize: 22)
        customCalendarHeader.text = getCurrentDate()
        
        self.addSubview(customCalendarHeader)
        
        customCalendarHeader.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(44)
        }
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
        
        self.addSubview(calendar)
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(customCalendarHeader.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(280)
        }
    }
}

// MARK: - Swipe Gestures
private extension CalendarView {
    func swipeAction() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        calendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        guard !(calendar.scope == .month && gesture.direction == .down) else { return }
        guard !(calendar.scope == .week && gesture.direction == .up) else { return }
        
        handleCalendarViewGesture()
    }
    
    func handleCalendarViewGesture() {
        calendarGestureCallback?()
        calendar.snp.updateConstraints { make in
            make.height.equalTo(self.frame.height)
        }
        calendar.scope = (calendar.scope == .month) ? .week : .month
    }
}


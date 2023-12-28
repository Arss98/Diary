//
//  CalendarView.swift
//  Diary
//
//  Created by  Arsen Dadaev on 27.12.2023.
//

import UIKit
import FSCalendar
import SnapKit
import Foundation

final class CalendarView: UIView {
    
    private let calendar = FSCalendar()
    private let customCalendarHeader = UILabel()
    private let selectDateButton = UIButton(type: .system)
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - FSCalendarDelegate, FSCalendarDataSource
extension CalendarView: FSCalendarDelegate, FSCalendarDataSource {
    private func initialize() {
        setupCustomCalendarHeader()
        setupSelectDateButton()
        setupCustomTitleStackView()
        setupСalendar()
    }
    
    private func setupСalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        
        self.addSubview(calendar)
        
        customizeCalendarAppearance()
        
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let monthYearString = dateFormatter.string(from: currentPage)
        customCalendarHeader.text = monthYearString
    }

}

//MARK: - CalendarView Setup
private extension CalendarView {
    func setupCustomTitleStackView() {
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(customCalendarHeader)
        stackView.addArrangedSubview(selectDateButton)
        
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(44)
        }
    }

    func setupCustomCalendarHeader() {
        customCalendarHeader.textAlignment = .left
        customCalendarHeader.textColor = .white
        customCalendarHeader.font = .systemFont(ofSize: 22)
        
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "MMMM yyyy"
        customCalendarHeader.text  = dateFormator.string(from: Date())
        
        self.addSubview(customCalendarHeader)
    }
    
    func setupSelectDateButton() {
        if let image = UIImage(named: "chevron.down") {
            selectDateButton.setImage(image, for: .normal)
        }
        selectDateButton.tintColor = .white
        
        self.addSubview(selectDateButton)
    }
    
    func customizeCalendarAppearance() {
        calendar.headerHeight = 0
        calendar.appearance.titleFont = .systemFont(ofSize: 17)
        calendar.appearance.weekdayFont = .systemFont(ofSize: 17)
        
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .red
        calendar.appearance.todaySelectionColor = .white
        calendar.appearance.titleSelectionColor = .background
        calendar.appearance.selectionColor = .white
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}


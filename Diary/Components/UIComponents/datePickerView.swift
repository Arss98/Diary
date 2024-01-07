//
//  datePickerView.swift
//  Diary
//
//  Created by  Arsen Dadaev on 07.01.2024.
//

import UIKit
import SnapKit

enum TypeDatePicker {
    case startDate
    case endDate
}

class datePickerView: UIView {
    private let label: CustomHeaderView
    private let datePicker = UIDatePicker()
    
    var date: Date {
        return datePicker.date
    }
    
    init(title: String, type: TypeDatePicker = .startDate) {
        self.label = CustomHeaderView(textLabel: title, fontSize: 20, fontWeight: .regular)
        super.init(frame: .zero)
        
        initialize()
        setupCurrentDate(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Constraints setting
private extension datePickerView {
    func initialize() {
        self.addSubview(datePicker)
        self.addSubview(label)
    
        setupConstraints()
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.bottom.equalToSuperview()
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
    }
}

//MARK: - Setting default date
private extension datePickerView {
    func setupCurrentDate(type: TypeDatePicker) {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        
        switch type {
        case .startDate:
            dateComponents.minute = (dateComponents.minute! < 30) ? 0 : 30
        case .endDate:
            dateComponents.hour! += 1
            dateComponents.minute! = 0
        }
        
        guard let date = Calendar.current.date(from: dateComponents) else { return }
        
        datePicker.setDate(date, animated: true)
    }
}

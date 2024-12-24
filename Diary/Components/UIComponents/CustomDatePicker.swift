import UIKit
import SnapKit

enum TypeDatePicker {
    case startDate
    case endDate
}

class CustomDatePicker: UIDatePicker {
    private let label: CustomHeaderView
    
    init(title: String) {
        self.label = CustomHeaderView(textLabel: title, fontSize: 20, fontWeight: .regular)
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Constraints setting
private extension CustomDatePicker {
    func initialize() {
        self.addSubview(label)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview()
        }
    }
}

// MARK: - Setting default date
extension CustomDatePicker {
    func setupCurrentDate(inputDate: Date, type: TypeDatePicker = .startDate) {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: inputDate)
        let currentComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        
        dateComponents.hour = currentComponents.hour
        dateComponents.minute = currentComponents.minute
        
        switch type {
        case .startDate:
            dateComponents.minute = (dateComponents.minute! <= 30) ? 0 : 30
        case .endDate:
            dateComponents.hour! += 1
            dateComponents.minute = 0
        }
        
        guard let date = calendar.date(from: dateComponents) else { return }
        self.setDate(date, animated: true)
    }
}

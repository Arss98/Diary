import UIKit
import SnapKit

final class DetailTaskView: UIView {
    lazy var titleTask = UILabel()
    lazy var dateInterval = UILabel()
    lazy var descriptionTask = UILabel()
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DetailTaskView {
    func initialize() {
        addSubview()
        setupConstraints()
        setupUIComponents()
    }
    
    func addSubview() {
        [titleTask, dateInterval, descriptionTask]
            .forEach { addSubview($0) }
    }
    
    func setupConstraints() {
        titleTask.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.leading.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
        
        dateInterval.snp.makeConstraints { make in
            make.top.equalTo(titleTask.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        descriptionTask.snp.makeConstraints { make in
            make.top.equalTo(dateInterval.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setupUIComponents() {
        titleTask.font = .systemFont(ofSize: 24, weight: .medium)
        
        dateInterval.textColor = .lightGray
        dateInterval.font = .systemFont(ofSize: 16, weight: .regular)
        dateInterval.numberOfLines = 2
        
        descriptionTask.font = .systemFont(ofSize: 18, weight: .regular)
        descriptionTask.numberOfLines = 0
    }
}

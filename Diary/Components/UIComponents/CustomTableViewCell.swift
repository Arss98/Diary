import UIKit
import SnapKit

final class CustomTableViewCell: UITableViewCell {
    private let nameTaskLabel = UILabel()
    private let dateInterval = UILabel()
    private let backgroundCellView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(from dateStart: String, to dateFinish: String, nameTask: String) {
        dateInterval.text = "\(dateStart) - \(dateFinish)"
        nameTaskLabel.text = nameTask
    }
}

private extension CustomTableViewCell {
    func initialize() {
        addSubview()
        setupConstraints()
        setupNameTaskLabel()
        setupDateIntervalLabel()
        setupBackgroundCellView()
    }
    
    func addSubview() {
        contentView.addSubview(backgroundCellView)
        [nameTaskLabel, dateInterval]
            .forEach { backgroundCellView.addSubview($0) }
    }
    
    func setupConstraints() {
        backgroundCellView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        nameTaskLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(250)
        }
        
        dateInterval.snp.makeConstraints { make in
            make.top.equalTo(nameTaskLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setupBackgroundCellView() {
        backgroundCellView.backgroundColor = .white
        backgroundCellView.layer.cornerRadius = 16
        backgroundCellView.layer.borderWidth = 0.4
        backgroundCellView.layer.borderColor = UIColor.clear.cgColor
        
        backgroundCellView.layer.shadowColor = UIColor.black.cgColor
        backgroundCellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backgroundCellView.layer.shadowOpacity = 0.2
        backgroundCellView.layer.shadowRadius = 3.5
    }
    
    func setupNameTaskLabel() {
        nameTaskLabel.textColor = .black
        nameTaskLabel.textAlignment = .left
        nameTaskLabel.font = .systemFont(ofSize: 20, weight: .medium)
    }
    
    func setupDateIntervalLabel() {
        dateInterval.font = .systemFont(ofSize: 14, weight: .regular)
        dateInterval.textColor = .gray
    }
}

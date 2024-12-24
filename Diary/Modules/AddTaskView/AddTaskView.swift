import UIKit
import SnapKit

final class AddTaskView: UIView {
    lazy var createButton = UIButton(type: .system)
    lazy var startDatePicker = CustomDatePicker(title: Consts.UIConstants.startDateTitle)
    lazy var finishDatePicker = CustomDatePicker(title: Consts.UIConstants.endDateTitle)
    lazy var nameTextView = CustomTextView(label: Consts.Headers.headerTaskTitle,
                                           errorLabel: Consts.ErrorMessages.errorTitle,
                                           placeholder: Consts.Placeholders.placeholderTaskTitle)
    lazy var descriptionTextView = CustomTextView(label: Consts.Headers.headerTaskDescription,
                                                  errorLabel: Consts.ErrorMessages.errorDescription,
                                                  placeholder: Consts.Placeholders.placeholderNodeText,
                                                  typeTextView: .description)
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AddTaskView {
    func initialize() {
        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 32
        self.backgroundColor = .white
        
        [startDatePicker, finishDatePicker, nameTextView, descriptionTextView, createButton]
            .forEach { addSubview($0) }
        
        createButton.setTitle(Consts.UIConstants.saveButtonTitle, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        createButton.backgroundColor = .mainBackground
        createButton.tintColor = .white
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
    }
    
    func setupConstraints() {
        startDatePicker.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        finishDatePicker.snp.makeConstraints { make in
            make.top.equalTo(startDatePicker.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        nameTextView.snp.makeConstraints { make in
            make.top.equalTo(finishDatePicker.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(nameTextView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        createButton.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(64)
        }
    }
}

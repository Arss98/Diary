//
//  AddTaskView.swift
//  Diary
//
//  Created by  Arsen Dadaev on 11.01.2024.
//

import UIKit
import SnapKit

final class AddTaskView: UIView {
    lazy var saveButton = UIButton(type: .system)
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
        setupSaveButton()
        setupBackgroundView()
        setupConstraints()
    }
    
    func setupSaveButton() {
        saveButton.setTitle(Consts.UIConstants.saveButtonTitle, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        saveButton.backgroundColor = .mainBackground
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        saveButton.layer.masksToBounds = true
    }
    
    func setupBackgroundView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 24
        self.backgroundColor = .white
        
        [startDatePicker, finishDatePicker, nameTextView, descriptionTextView, saveButton]
            .forEach { addSubview($0) }
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
        
        saveButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(32)
            make.width.equalTo(140)
            make.height.equalTo(50)
        }
    }
}

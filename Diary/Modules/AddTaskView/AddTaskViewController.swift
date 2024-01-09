//
//  AddTaskViewController.swift
//  Diary
//
//  Created by  Arsen Dadaev on 05.01.2024.
//

import UIKit
import SnapKit

class AddTaskViewController: UIViewController {
    private let backgroundView = UIView()
    private let saveButton = UIButton(type: .system)
    private let startDatePicker = datePickerView(title: Consts.startDateTitle)
    private let finishDatePicker = datePickerView(title: Consts.endDateTitle, type: .endDate)
    private let nameTextField = LabeledTextView(title: Consts.headerTaskTitle,
                                                placeholder: Consts.placeholderTaskTitle)
    private let descriptionTextField = LabeledTextView(title: Consts.headerTaskDescription,
                                                       placeholder: Consts.placeholderNodeText,
                                                       typeTextView: .description)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
    }
}

//MARK: - UI settings
private extension AddTaskViewController {
    func initialize() {
        view.backgroundColor = .mainBackground
        view.addSubview(backgroundView)
        
        setupNavigationBar()
        setupBackgroundView()
        setupSaveButton()
        setupConstraints()
    }
    
    func setupSaveButton() {
        saveButton.setTitle(Consts.saveButtonTitle, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        saveButton.backgroundColor = .mainBackground
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        saveButton.layer.masksToBounds = true
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    func setupBackgroundView() {
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 24
        backgroundView.backgroundColor = .white
        
        backgroundView.addSubview(startDatePicker)
        backgroundView.addSubview(finishDatePicker)
        backgroundView.addSubview(nameTextField)
        backgroundView.addSubview(descriptionTextField)
        backgroundView.addSubview(saveButton)
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.title = Consts.AddTaskTitle
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
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(finishDatePicker.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        saveButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(32)
            make.width.equalTo(140)
            make.height.equalTo(50)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
}

private extension AddTaskViewController {
    @objc func saveButtonTapped() {
        print(startDatePicker.date)
    }
}

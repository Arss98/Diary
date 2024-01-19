//
//  AddTaskViewController.swift
//  Diary
//
//  Created by  Arsen Dadaev on 05.01.2024.
//

import UIKit
import SnapKit

enum TypeTaskViewController {
    case add
    case edit
}

final class AddTaskViewController: UIViewController {
    private let viewModel = AddTaskViewModel()
    private let contentView = AddTaskView()
    private let type: TypeTaskViewController
    private var topConstraint: Constraint?
    private var activeInput: UITextView?
    private var id: String?
    
    init(selectedDate: Date, typeView: TypeTaskViewController = .add) {
        self.type = typeView
        super.init(nibName: nil, bundle: nil)
        contentView.startDatePicker.setupCurrentDate(inputDate: selectedDate)
        contentView.finishDatePicker.setupCurrentDate(inputDate: selectedDate, type: .endDate)
    }
    
    convenience init(id: String, title: String, description: String, selectedDate: Date) {
        self.init(selectedDate: selectedDate, typeView: .edit)
        self.id = id
        self.contentView.nameTextView.textView.text = title
        self.contentView.nameTextView.textView.textColor = .black
        self.contentView.descriptionTextView.textView.text = description
        self.contentView.descriptionTextView.textView.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setupDelegateCustomTextView()
        setupKeyboardNotifications()
        registerGesture()
    }
}

// MARK: - UITextViewDelegate
extension AddTaskViewController: UITextViewDelegate {
    func setupDelegateCustomTextView() {
        contentView.nameTextView.setupDelegate(delegate: self)
        contentView.descriptionTextView.setupDelegate(delegate: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.activeInput = textView
        
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.isEmpty {
            textView.text = (textView == contentView.nameTextView.textView) ? Consts.Placeholders.placeholderTaskTitle : Consts.Placeholders.placeholderNodeText
            textView.textColor = .lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView == contentView.nameTextView.textView {
                contentView.descriptionTextView.textView.becomeFirstResponder()
            } else {
                textView.insertText("\n")
            }
            return false
        }
        return true
    }
}

// MARK: - UI settings
private extension AddTaskViewController {
    func initialize() {
        view.backgroundColor = .mainBackground
        view.addSubview(contentView)
        
        contentView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        setupNavigationBar()
        setupConstraints()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        switch type {
        case .add:
            self.title = Consts.Headers.addTaskTitle
        case .edit:
            self.title = Consts.Headers.editTaskTitle
            let rightButton = UIBarButtonItem(title: Consts.UIConstants.deleteButtonTitle, style: .plain, target: self, action: #selector(deleteButtonTapped))
            navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            self.topConstraint = make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32).constraint
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Keyboard setting
private extension AddTaskViewController {
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let activeInput = self.activeInput else { return }
        
        let bottomOfTextField = activeInput.convert(activeInput.bounds, to: self.contentView).maxY
        
        if bottomOfTextField > keyboardSize.height {
            let heightOverlap = keyboardSize.height - activeInput.convert(activeInput.bounds, to: self.contentView).minY
            
            self.topConstraint?.update(offset: -heightOverlap)
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.view.layoutIfNeeded()
            }
        } else {
            self.topConstraint?.update(offset: 32)
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.topConstraint?.update(offset: 32)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func registerGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

// MARK: - Data validation check
private extension AddTaskViewController {
    @objc func deleteButtonTapped() {
        guard let taskId = id else { return }
        
        showDeleteAlert(title: Consts.Alerts.deleteAlertTitle, message: Consts.Alerts.deleteAlertDescription) {
            self.viewModel.deleteTask(id: taskId)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func saveButtonTapped() {
        guard let data = viewModel.validateInput(
            title: contentView.nameTextView.text,
            description: contentView.descriptionTextView.text) else {
            contentView.nameTextView.isHiddenErrorLabel = false
            contentView.descriptionTextView.isHiddenErrorLabel = false
            showErroeAlert(title: Consts.ErrorMessages.alertError, message: Consts.ErrorMessages.alertErrorMessage)
            return
        }
        
        switch type {
        case .add:
            saveNewTask(title: data.title, description: data.description)
        case .edit:
            updateExistingTask(title: data.title, description: data.description)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func saveNewTask(title: String, description: String) {
        viewModel.saveTask(
            title: title,
            description: description,
            dateStart: contentView.startDatePicker.date,
            dateFinish: contentView.finishDatePicker.date)
    }
    
    func updateExistingTask(title: String, description: String) {
        guard let taskId = id else { return }
        
        viewModel.updateTask(
            id: taskId,
            title: title,
            description: description,
            dateStart: contentView.startDatePicker.date,
            dateFinish: contentView.finishDatePicker.date)
    }
}

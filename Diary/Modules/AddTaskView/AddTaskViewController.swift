//
//  AddTaskViewController.swift
//  Diary
//
//  Created by  Arsen Dadaev on 05.01.2024.
//

import UIKit
import SnapKit

final class AddTaskViewController: UIViewController {
    private let viewModel = AddTaskViewModel()
    private let contentView = AddTaskView()
    private var keyboardHandler: KeyboardHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler = KeyboardHandler(viewController: self)
        initialize()
        setupDelegateCustomTextView()
    }
}

// MARK: - UITextViewDelegate
extension AddTaskViewController: UITextViewDelegate {
    func setupDelegateCustomTextView() {
        contentView.nameTextView.setupDelegate(delegate: self)
        contentView.descriptionTextView.setupDelegate(delegate: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        keyboardHandler?.activeInput = textView
        
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            if textView == contentView.nameTextView.textView {
                contentView.descriptionTextView.textView.becomeFirstResponder()
            } else {
                textView.resignFirstResponder()
            }
            return false
        }
        return true
    }
}

//MARK: - UI settings
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
        
        self.title = Consts.AddTaskTitle
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - Data validation check
private extension AddTaskViewController {
    @objc func saveButtonTapped() {
        if let data = viewModel.validateInput(title: contentView.nameTextView.text, description: contentView.descriptionTextView.text) {
            viewModel.saveData(title: data.title,
                               description: data.description,
                               dateStart: contentView.startDatePicker.date,
                               dateFinish: contentView.finishDatePicker.date)
            
            navigationController?.popViewController(animated: true)
        } else {
            contentView.nameTextView.isHiddenErrorLabel = false
            contentView.descriptionTextView.isHiddenErrorLabel = false
            showAlert()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: Consts.ErrorMessage.alertError, message: Consts.ErrorMessage.alertErrorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Consts.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

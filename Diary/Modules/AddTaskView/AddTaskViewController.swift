import UIKit
import SnapKit

final class AddTaskViewController: UIViewController {
    var presenter: AddTaskPresenterProtocol?
    
    private let contentView = AddTaskView()
    private var topConstraint: Constraint?
    private var activeInput: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.determineScreenMode()
        setupDelegateCustomTextView()
        setupKeyboardNotifications()
        registerGesture()
    }
}

// MARK: - AddTaskViewProtocol
extension AddTaskViewController: AddTaskViewProtocol {
    func setupUIData(task: TaskDomain) {
        self.contentView.nameTextView.textView.text = task.title
        self.contentView.nameTextView.textView.textColor = .black
        self.contentView.descriptionTextView.textView.text = task.descriptionTask
        self.contentView.descriptionTextView.textView.textColor = .black
    }
    
    func setupDate(date: Date) {
        self.contentView.startDatePicker.setupCurrentDate(inputDate: date)
        self.contentView.finishDatePicker.setupCurrentDate(inputDate: date, type: .endDate)
    }
    
    func setupNavigationBar(title: String, showDeleteButton: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.title = title
        
        if showDeleteButton {
            let rightButton = UIBarButtonItem(title: Consts.UIConstants.deleteButtonTitle, style: .plain, target: self, action: #selector(deleteButtonTapped))
            navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    func showError(message: String) {
        self.showErroeAlert(title: Consts.Alerts.alertErrorTitle, message: message)
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
        
        contentView.createButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        setupConstraints()
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
        showDeleteAlert(title: Consts.Alerts.deleteAlertTitle, message: Consts.Alerts.deleteAlertDescription) {
            self.presenter?.deleteTask()
        }
    }
    
    @objc func saveButtonTapped() {
        self.presenter?.saveTask(
            title: contentView.nameTextView.text,
            description: contentView.descriptionTextView.text,
            dateStart: contentView.startDatePicker.date,
            dateFinish: contentView.finishDatePicker.date
        )
    }
}

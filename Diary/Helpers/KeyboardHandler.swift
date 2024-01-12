import UIKit

final class KeyboardHandler: NSObject {
    let viewController: UIViewController
    var activeInput: UIView?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
        setupKeyboardNotifications()
        registerGesture()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let activeInput = activeInput else {
            return
        }
        
        let inputFrameInWindow = activeInput.convert(activeInput.bounds, to: nil)
        let intersect = inputFrameInWindow.intersection(keyboardSize)
        
        if !intersect.isNull {
            let offset = intersect.height + 10
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: offset, right: 0)
            
            UIView.animate(withDuration: 0.3) {
                self.viewController.view.frame.origin.y = -offset
                self.viewController.additionalSafeAreaInsets = contentInsets
                self.viewController.view.layoutIfNeeded()
            }
            self.viewController.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.viewController.view.frame.origin.y = 0
            self.viewController.additionalSafeAreaInsets = .zero
            self.viewController.view.layoutIfNeeded()
        }
        
        self.viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        activeInput = nil
    }
}

//MARK: - Register Gesture
private extension KeyboardHandler {
    func registerGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        viewController.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        viewController.view.endEditing(true)
    }
}

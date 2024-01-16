import UIKit

final class KeyboardHandler: NSObject {
    let viewController: UIViewController
    var activeInput: UITextView?
    
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
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let activeInput = activeInput else { return }
        
        var shouldMoveViewUp = false
        
        let bottomOfTextField = activeInput.convert(activeInput.bounds, to: viewController.view).maxY;
        let topOfKeyboard = viewController.view.frame.height - keyboardSize.height
        if bottomOfTextField > topOfKeyboard {
            shouldMoveViewUp = true
        }
        
        
        if(shouldMoveViewUp) {
            self.viewController.view.frame.origin.y -= keyboardSize.height
            viewController.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        viewController.view.frame.origin.y = 0
        viewController.navigationController?.isNavigationBarHidden = false
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

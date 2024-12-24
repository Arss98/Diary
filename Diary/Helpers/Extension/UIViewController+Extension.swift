import UIKit

extension UIViewController {
    func showErroeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Consts.UIConstants.okButton, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteAlert(title: String, message: String, deleteHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Consts.UIConstants.cancelButtonTitle, style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: Consts.UIConstants.deleteButtonTitle, style: .destructive) { _ in
            deleteHandler()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

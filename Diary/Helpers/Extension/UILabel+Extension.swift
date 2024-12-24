import UIKit

extension UILabel {
    func addMargins(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        let insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        self.drawText(in: self.bounds.inset(by: insets))
    }
}

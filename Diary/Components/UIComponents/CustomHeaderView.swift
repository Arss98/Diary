import UIKit
import SnapKit

class CustomHeaderView: UIView {
    private let label = UILabel()
    
    init(textLabel: String, fontSize: CGFloat = 24, fontWeight: UIFont.Weight = .medium, textColor: UIColor = .black) {
        super.init(frame: .zero)
        setupTableHeader(textLabel: textLabel, fontSize: fontSize, fontWeight: fontWeight, textColor: textColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CustomHeaderView {
    func setupTableHeader(textLabel: String, fontSize: CGFloat, fontWeight: UIFont.Weight, textColor: UIColor) {
        label.text = textLabel
        label.textAlignment = .left
        label.textColor = textColor
        label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        
        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
}

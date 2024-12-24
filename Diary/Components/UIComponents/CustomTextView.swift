import UIKit
import SnapKit

enum TypeTextView {
    case title
    case description
}

class CustomTextView: UIView {
    let textView = UITextView()
    private let label: CustomHeaderView
    private let errorLabel = UILabel()
    private let placeholderText: String
    private let type: TypeTextView
    
    var text: String? {
        if textView.text == placeholderText || textView.text == "" {
            return nil
        } else {
            return textView.text
        }
    }
    
    var isHiddenErrorLabel: Bool = true {
        didSet {
            self.errorLabel.isHidden = isHiddenErrorLabel
        }
    }
    
    init(label: String, errorLabel: String, placeholder: String, typeTextView: TypeTextView = .title) {
        self.label = CustomHeaderView(textLabel: label, fontWeight: .regular)
        self.errorLabel.text = errorLabel
        self.placeholderText = placeholder
        self.type = typeTextView
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDelegate(delegate: UITextViewDelegate) {
        textView.delegate = delegate
    }
}

// MARK: - UI settings
private extension CustomTextView {
    func initialize() {
        addSubview()
        configureTextView()
        setupLabel()
    }
    
    func addSubview() {
        [label, textView, errorLabel]
            .forEach { addSubview($0)}
    }
    
    func setupConstraints(textViewHeight: UInt) {
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textViewHeight)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupTextView(numberOfLines: Int, isScrollEnabled: Bool) {
        textView.backgroundColor = .textFieldBackground
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = isScrollEnabled
        textView.textContainer.maximumNumberOfLines = numberOfLines
        textView.textContainer.lineBreakMode = .byCharWrapping
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.text = placeholderText
        textView.textColor = .lightGray
        textView.returnKeyType = .done
    }
    
    func setupLabel() {
        errorLabel.textAlignment = .left
        errorLabel.textColor = .red
        errorLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        errorLabel.isHidden = true
    }
    
    func configureTextView() {
        switch type {
        case .title:
            setupConstraints(textViewHeight: 40)
            setupTextView(numberOfLines: 1, isScrollEnabled: false)
        case .description:
            setupConstraints(textViewHeight: 160)
            setupTextView(numberOfLines: 0, isScrollEnabled: true)
        }
    }
}

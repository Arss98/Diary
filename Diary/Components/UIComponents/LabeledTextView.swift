//
//  LabeledTextView.swift
//  Diary
//
//  Created by  Arsen Dadaev on 06.01.2024.
//

import UIKit
import SnapKit

enum TextViewType {
    case title
    case description
}

class LabeledTextView: UIView {
    private let label: CustomHeaderView
    private let textView = UITextView()
    private let placeholderText: String
    private let type: TextViewType
    
    var text: String? {
        if textView.text == placeholderText {
            return nil
        } else {
            return textView.text
        }
    }
    
    init(title: String, placeholder: String, typeTextView: TextViewType = .title) {
        self.label = CustomHeaderView(textLabel: title, fontWeight: .regular)
        self.placeholderText = placeholder
        self.type = typeTextView
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITextViewDelegate
extension LabeledTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
}

// MARK: - UI settings
private extension LabeledTextView {
    func initialize() {
        textView.delegate = self
        self.addSubview(label)
        self.addSubview(textView)
        
        configureTextView()
    }
    
    func setupConstraints(textViewHeight: UInt) {
        label.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(textViewHeight)
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

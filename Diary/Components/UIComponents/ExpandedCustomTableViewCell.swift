//
//  ExpandedCustomTableViewCell.swift
//  Diary
//
//  Created by  Arsen Dadaev on 20.01.2024.
//

import UIKit
import SnapKit

final class ExpandedCustomTableViewCell: UITableViewCell {
    private let startTime = UILabel()
    private let nameTaskLabel = UILabel()
    private let lineView = UIView()
    private let backgroundCellView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
      
    func configure(startTime: String, title: String? = nil) {
        self.startTime.text = startTime
        
        if title != nil {
            self.backgroundCellView.isHidden = false
            self.nameTaskLabel.text = title
        } else {
            self.nameTaskLabel.text = nil
            self.backgroundCellView.isHidden = true
        }
    }
}

private extension ExpandedCustomTableViewCell {
    func initialize() {
        addSubview()
        setupConstraints()
        setupBackgroundCellView()
        setupUIComponents()
    }
    
    func addSubview() {
        [startTime, lineView, backgroundCellView]
            .forEach { addSubview($0)}
        
        backgroundCellView.addSubview(nameTaskLabel)
    }
    
    func setupConstraints() {
        startTime.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.width.equalTo(44)
        }
        
        lineView.snp.makeConstraints { make in
            make.centerY.equalTo(startTime.snp.centerY)
            make.trailing.equalToSuperview().inset(8)
            make.leading.equalTo(startTime.snp.trailing)
            make.height.equalTo(1)
        }
        
        backgroundCellView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(4)
            make.width.equalTo(lineView.snp.width)
            make.height.equalTo(40)
        }
        
        nameTaskLabel.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
                .inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8))
        }
    }
    
    func setupBackgroundCellView() {
        backgroundCellView.backgroundColor = .white
        backgroundCellView.layer.cornerRadius = 8
        backgroundCellView.layer.borderWidth = 0.4
        backgroundCellView.layer.borderColor = UIColor.clear.cgColor
        
        backgroundCellView.layer.shadowColor = UIColor.black.cgColor
        backgroundCellView.layer.shadowOffset = CGSize(width: 2, height: 3)
        backgroundCellView.layer.shadowOpacity = 0.2
        backgroundCellView.layer.shadowRadius = 3.5
    }
    
    func setupUIComponents() {
        lineView.backgroundColor = .lightGray
        
        startTime.font = .systemFont(ofSize: 14, weight: .thin)
        startTime.textAlignment = .left
        
        nameTaskLabel.font = .systemFont(ofSize: 18, weight: .regular)
    }
}

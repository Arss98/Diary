//
//  CustomTableViewCell.swift
//  Diary
//
//  Created by  Arsen Dadaev on 28.12.2023.
//

import UIKit
import SnapKit

class CustomTableViewCell: UITableViewCell {
    private let dateStartLabel = UILabel()
    private let dateFinishLabel = UILabel()
    private let nameTaskLabel = UILabel()
    private let dateIntervalStack = UIStackView()
    private let cellStack = UIStackView()
    private let shadowContainer = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(from dateStart: String, to dateFinish: String, nameTask: String) {
        dateStartLabel.text = dateStart
        dateFinishLabel.text = dateFinish
        nameTaskLabel.text = nameTask
    }
    
}

private extension CustomTableViewCell {
    func initialize() {
        setupNameTaskLabel()
        setupDateIntervalStack()
        setupCellStack()
    }
    
    func setupNameTaskLabel() {
        shadowContainer.layer.shadowColor = UIColor.black.cgColor
        shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowContainer.layer.shadowRadius = 4
        shadowContainer.layer.shadowOpacity = 0.2
        shadowContainer.backgroundColor = .clear
        
        contentView.addSubview(shadowContainer)
        shadowContainer.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(50)
        }

        shadowContainer.addSubview(nameTaskLabel)
        nameTaskLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameTaskLabel.backgroundColor = .white
        nameTaskLabel.layer.cornerRadius = 20
        nameTaskLabel.layer.masksToBounds = true
        
        nameTaskLabel.textColor = .black
        nameTaskLabel.textAlignment = .center
    }

    func setupDateIntervalStack() {
        dateIntervalStack.axis = .vertical
        dateIntervalStack.spacing = 0
        dateIntervalStack.alignment = .leading
        
        dateIntervalStack.addArrangedSubview(dateStartLabel)
        dateIntervalStack.addArrangedSubview(dateFinishLabel)
    }
    
    func setupCellStack() {
        cellStack.translatesAutoresizingMaskIntoConstraints = false
        cellStack.axis = .horizontal
        cellStack.spacing = 0
        
        
        cellStack.addArrangedSubview(dateIntervalStack)
        cellStack.addArrangedSubview(shadowContainer)
        
        contentView.addSubview(cellStack)
        
        cellStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
}

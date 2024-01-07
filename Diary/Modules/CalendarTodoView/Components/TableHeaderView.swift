//
//  TableHeaderView.swift
//  Diary
//
//  Created by  Arsen Dadaev on 28.12.2023.
//

import UIKit
import SnapKit

class TableHeaderView: UIView {
    private let tableHeaderLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TableHeaderView {
    func setupTableHeader() {
        tableHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderLabel.text = Consts.tableHeaderView
        tableHeaderLabel.textAlignment = .left
        tableHeaderLabel.textColor = .black
        tableHeaderLabel.font = .systemFont(ofSize: 24, weight: .medium)
        
        self.addSubview(tableHeaderLabel)
        
        tableHeaderLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().offset(16)
        }
    }
}

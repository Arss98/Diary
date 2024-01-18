//
//  DetailTaskViewController.swift
//  Diary
//
//  Created by  Arsen Dadaev on 13.01.2024.
//

import UIKit
import SnapKit

class DetailTaskViewController: UIViewController {
    private let id: String
    private let viewModel = DetailTaskViewModel()
    private let contentView = DetailTaskView()
    
    init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadData(id: id)
        setupData()
    }
}

// MARK: UI Setting
private extension DetailTaskViewController {
    func initialize() {
        view.backgroundColor = .mainBackground
        view.addSubview(contentView)
        
        setupNavigationBar()
        setupContentView()
    }
    
    func setupData() {
        contentView.titleTask.text = viewModel.output.title
        contentView.descriptionTask.text = viewModel.output.description
        contentView.dateInterval.text = viewModel.output.timeInterval
    }
    
    func setupNavigationBar() {
        self.title = Consts.detailTaskTitle
        self.navigationItem.backButtonTitle = Consts.backButtonTitle
        
        let rightButton = UIBarButtonItem(
            title: Consts.editButtonTitle,
            style: .plain,
            target: self,
            action: #selector(rightButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setupContentView() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .white
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Navigation
private extension DetailTaskViewController {
    @objc func rightButtonTapped() {
        let addTaskView = AddTaskViewController(id: id, selectedDate: viewModel.output.date)
        navigationController?.pushViewController(addTaskView, animated: true)
    }
}

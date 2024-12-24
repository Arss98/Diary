import UIKit
import SnapKit

class DetailTaskViewController: UIViewController {
    var presenter: DetailTaskPresenterProtocol?
    
    private let contentView = DetailTaskView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.loadTask()
    }
}

// MARK: - DetailTaskViewProtocol
extension DetailTaskViewController: DetailTaskViewProtocol {
    func displayTask(title: String, description: String, timeInterval: String) {
        contentView.titleTask.text = title
        contentView.descriptionTask.text = description
        contentView.dateInterval.text = timeInterval
    }
    
    func displayError(message: String) {
        self.showErroeAlert(title: Consts.Alerts.alertErrorTitle, message: message)
    }
}

// MARK: - UI Setting
private extension DetailTaskViewController {
    func initialize() {
        view.backgroundColor = .mainBackground
        view.addSubview(contentView)
        
        setupNavigationBar()
        setupContentView()
    }
  
    func setupNavigationBar() {
        self.title = Consts.Headers.detailTaskTitle
        self.navigationItem.backButtonTitle = Consts.UIConstants.backButtonTitle
        
        let rightButton = UIBarButtonItem(
            title: Consts.UIConstants.editButtonTitle,
            style: .plain,
            target: self,
            action: #selector(rightButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func setupContentView() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 32
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
        guard let presenter = presenter else { return }
        presenter.editTaskButtonTapped()
    }
}

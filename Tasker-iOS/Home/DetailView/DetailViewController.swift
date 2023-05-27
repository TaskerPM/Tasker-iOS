//
//  DetailViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/25.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    private let saveButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = "저장"
        config.attributedTitle?.font = .pretendardFont(size: 13, style: .semiBold)
        config.baseForegroundColor = .setColor(.gray900)
        return UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            // TODO: 저장 버튼을 누르면 컨텐츠를 서버에 저장하는 로직 호출 (뒤로 가기 x)
            print("Tapped saveNote")
        }))
    }()
    
    private let todoTitleTextField: UITextField = {
        let textField = UITextField()
        textField.text = "프로젝트 이름"
        textField.font = .pretendardFont(size: 16, style: .semiBold)
        textField.textColor = .setColor(.basicBlack)
        return textField
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.textColor = .setColor(.black)
        label.font = .pretendardFont(size: 14, style: .regular)
        return label
    }()
    
    private lazy var categorySelectButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = "선택 안 함"
        config.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        config.baseForegroundColor = .setColor(.white)
        config.background.backgroundColor = .setColor(.gray300)
        config.background.cornerRadius = 5
        config.attributedTitle?.font = .pretendardFont(size: 12, style: .regular)
        return UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            print("Tapped categorySelectButton")
            let categoryListVC = CategoryListViewController()
            self.navigationController?.pushViewController(categoryListVC, animated: true)
        }))
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.textColor = .setColor(.black)
        label.font = .pretendardFont(size: 14, style: .regular)
        return label
    }()
    
    private lazy var timeSelectButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = "선택 안 함"
        config.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        config.baseForegroundColor = .setColor(.white)
        config.background.backgroundColor = .setColor(.gray300)
        config.background.cornerRadius = 5
        config.attributedTitle?.font = .pretendardFont(size: 12, style: .regular)
        return UIButton(configuration: config, primaryAction: UIAction(handler: { _ in
            print("Tapped timeSelectButton")
            let timePickerVC = TimePickerViewController()
            timePickerVC.modalPresentationStyle = .custom
            timePickerVC.transitioningDelegate = self
            self.present(timePickerVC, animated: true)
        }))
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let seperateLineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.setColor(.gray30).cgColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setColor(.white)
        
        configureNavigationBar()
        configureUI()
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        todoTitleTextField.becomeFirstResponder()
    }
    
    private func configureNavigationBar() {
        let navigationBack = UIImage(named: "navigation_back")
        let backBarButton = UIBarButtonItem(image: navigationBack, style: .plain, target: self, action: #selector(popToVC))
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = .setColor(.gray900)
        self.navigationItem.rightBarButtonItem = saveBarButton
    }
    
    @objc func popToVC() {
//        self.navigationController?.popViewController(animated: true)
        print("Tapped popToVC")
    }
    
    private func configureUI() {
        [categoryLabel, categorySelectButton]
            .forEach(categoryStackView.addArrangedSubview)
        
        [timeLabel, timeSelectButton]
            .forEach(timeStackView.addArrangedSubview)
        
        [todoTitleTextField, categoryStackView, timeStackView, seperateLineView]
            .forEach(view.addSubview)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        todoTitleTextField.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top)
            $0.leading.trailing.equalToSuperview().offset(18)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.top.equalTo(todoTitleTextField.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview().inset(21)
        }
        
        timeStackView.snp.makeConstraints {
            $0.top.equalTo(categoryStackView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(21)
        }
        
        seperateLineView.snp.makeConstraints {
            $0.top.equalTo(timeStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalViewPresentationController(presentedViewController: presented, presenting: presentingViewController)
    }
}

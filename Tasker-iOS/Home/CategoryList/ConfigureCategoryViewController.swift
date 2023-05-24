//
//  ConfigureCategoryViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/23.
//

import UIKit
import SnapKit

class ConfigureCategoryViewController: UIViewController {
    lazy var topTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardFont(size: 16, style: .regular)
        label.textColor = .setColor(.gray900)
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .pretendardFont(size: 13, style: .semiBold)
        button.setTitleColor(.setColor(.gray200), for: .normal)
        return button
    }()
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리 이름"
        label.textColor = .setColor(.black)
        label.font = .pretendardFont(size: 13, style: .medium)
        return label
    }()
    
    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 17.0, height: 0.0))
        textField.leftViewMode = .always
        textField.font = .pretendardFont(size: 13, style: .regular)
        textField.textColor = .setColor(.gray900)
        textField.tintColor = .setColor(.gray900)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.setColor(.gray100).cgColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private let colorNameLabel: UILabel = {
        let label = UILabel()
        label.text = "색상"
        label.textColor = .setColor(.black)
        label.font = .pretendardFont(size: 13, style: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .setColor(.white)
        
        configureNavigationBar()
        configureButtonAction()
        configureUI()
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        categoryTextField.becomeFirstResponder()
    }
    
    private func configureNavigationBar() {
        let navigationBack = UIImage(named: "navigation_back")
        
        let backBarButton = UIBarButtonItem(image: navigationBack, style: .plain, target: self, action: #selector(popToVC))
        let completeBarButton = UIBarButtonItem(customView: completeButton)
        
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = .setColor(.gray900)
        self.navigationItem.titleView = topTitleLabel
        self.navigationItem.rightBarButtonItem = completeBarButton
    }
    
    private func configureButtonAction() {
        completeButton.addAction(UIAction(handler: tappedCompleteButton), for: .touchUpInside)
    }
    
    private func tappedCompleteButton(_ action: UIAction) {
        // TODO: 카테고리 이름과 색상 선택 완료 시 버튼 색상 변경 및 서버 로직 호출 구현
        print("tappedCompleteButton Called")
    }

    @objc func popToVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeSetting() {
        print("Tapped completeSetting")
    }
    
    private func configureUI() {
        [categoryNameLabel, categoryTextField, colorNameLabel]
            .forEach(view.addSubview)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        categoryNameLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(9)
            $0.leading.equalToSuperview().offset(16)
        }
        
        categoryTextField.snp.makeConstraints {
            $0.top.equalTo(categoryNameLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        colorNameLabel.snp.makeConstraints {
            $0.top.equalTo(categoryTextField.snp.bottom).offset(30)
            $0.leading.equalTo(categoryNameLabel.snp.leading)
        }
    }
}


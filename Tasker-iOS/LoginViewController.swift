//
//  LoginViewController.swift
//  Tasker-iOS
//
//  Created by mingmac, Wonbi on 2023/03/28.
//

import UIKit

final class LoginViewController: UIViewController {
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "휴대폰번호를 입력해주세요."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let authNumberButton: UIButton = {
        let button = UIButton()
        button.setTitle("인증번호 받기", for: .normal)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureLayout()
    }
    
    private func button() {
        authNumberButton.addAction(UIAction(handler: buttonAction), for: .touchUpInside)
    }
    
    private func buttonAction(_ action: UIAction) {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        
        viewModel.action(.tapAuthNumber(phoneNumber: phoneNumber))
    }
    
    private func confirmButton() {
        viewModel.action(.confirm(userInput: "195873"))
    }
}


// MARK: - UI Components
extension LoginViewController {
    private func configureUI() {
        [phoneNumberTextField, authNumberButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            phoneNumberTextField.topAnchor.constraint(equalTo: safeArea.topAnchor),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 48),
            
            authNumberButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 16),
            authNumberButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            authNumberButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            authNumberButton.heightAnchor.constraint(equalTo: phoneNumberTextField.heightAnchor)
        ])
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func confirm(_ result: Bool) {
        if result == true {
            // 다음화면 푸시
        } else {
            // 인증번호가 틀립니다 얼럿
        }
    }
    
    func getAuthKey() {
        // 동의하고 시작하기 버튼 활성화
    }
}

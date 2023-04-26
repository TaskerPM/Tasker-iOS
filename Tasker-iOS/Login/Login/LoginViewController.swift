//
//  LoginViewController.swift
//  Tasker-iOS
//
//  Created by mingmac, Wonbi on 2023/03/28.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    private let accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 71.0))
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "휴대폰번호를 입력해주세요."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.keyboardType = .numberPad
        textField.textColor = .setColor(.gray900)
        textField.font = .pretendardFont(size: 13, style: .regular)
        return textField
    }()
    
    private let smsNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "인증번호 5자리를 입력해주세요.(3분 이내)"
        textField.layer.borderWidth = 1
        textField.keyboardType = .numberPad
        textField.textColor = .setColor(.gray900)
        textField.font = .pretendardFont(size: 13, style: .regular)
        return textField
    }()
    
    private let authNumberButton: UIButton = {
        let button = UIButton()
        button.setTitle("인증번호 받기", for: .normal)
        button.titleLabel?.font = .pretendardFont(size: 14, style: .semiBold)
        button.setTitleColor(.setColor(.white), for: .normal)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("개인정보처리방침", for: .normal)
        button.titleLabel?.font = .pretendardFont(size: 11, style: .regular)
        button.setUnderline()
        button.setTitleColor(.setColor(.gray250), for: .normal)
        return button
    }()
    
    private let dotLabel: UILabel = {
        let label = UILabel()
        label.text = "•"
        label.textColor = .setColor(.gray250)
        label.textAlignment = .center
        label.font = .pretendardFont(size: 11, style: .semiBold)
        return label
    }()
    
    private let userAgreeButton: UIButton = {
        let button = UIButton()
        button.setTitle("이용약관", for: .normal)
        button.titleLabel?.font = .pretendardFont(size: 11, style: .regular)
        button.setUnderline()
        button.setTitleColor(.setColor(.gray250), for: .normal)
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("동의하고 시작하기", for: .normal)
        button.titleLabel?.font = .pretendardFont(size: 15, style: .semiBold)
        button.setTitleColor(.setColor(.white), for: .normal)
        button.backgroundColor = .setColor(.basicRed)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
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
        configureButtonAction()
        
        viewModel.setDelegate(self)
        phoneNumberTextField.inputAccessoryView = accessoryView
        phoneNumberTextField.becomeFirstResponder()
    }
    
    private func configureButtonAction() {
        authNumberButton.addAction(UIAction(handler: tappedAuthNumberButton), for: .touchUpInside)
    }
    
    private func tappedAuthNumberButton(_ action: UIAction) {
        guard let phoneNumber = phoneNumberTextField.text else { return }
        
        viewModel.action(.tapAuthNumber(phoneNumber: phoneNumber))
    }
    
    private func tappedConfirmButton() {
        viewModel.action(.confirm(userInput: "텍스트 필드에 입력된 유저의 인풋이 들어와야 함"))
    }
}


// MARK: - UI Components
extension LoginViewController {
    private func configureUI() {
        [stackView, confirmButton].forEach {
            accessoryView.addSubview($0)
        }
        
        [phoneNumberTextField, authNumberButton].forEach {
            view.addSubview($0)
        }
        
        [privacyButton, dotLabel, userAgreeButton].forEach {
            stackView.addArrangedSubview($0)
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
        
        stackView.snp.makeConstraints {
            $0.centerX.equalTo(accessoryView.snp.centerX)
            $0.bottom.equalTo(confirmButton.snp.top).inset(-8)
            $0.height.equalTo(17)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.equalTo(accessoryView.snp.leading)
            $0.trailing.equalTo(accessoryView.snp.trailing)
            $0.bottom.equalTo(accessoryView.snp.bottom)
            $0.height.equalTo(54)
        }
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
}

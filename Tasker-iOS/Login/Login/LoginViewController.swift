//
//  LoginViewController.swift
//  Tasker-iOS
//
//  Created by mingmac, Wonbi on 2023/03/28.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .setColor(.gray900)
        label.font = .pretendardFont(size: 20, style: .bold)
        label.text = "안녕하세요!\n휴대폰 번호로 가입해주세요."
        label.numberOfLines = 2
        return label
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "휴대폰번호를 입력해주세요."
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 17.0, height: 0.0))
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor.setColor(.gray100).cgColor
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.keyboardType = .numberPad
        textField.tintColor = .setColor(.gray900)
        textField.textColor = .setColor(.gray900)
        textField.font = .pretendardFont(size: 13, style: .regular)
        return textField
    }()
    
    private let authNumberButton: UIButton = {
        let button = UIButton()
        button.setTitle("인증번호 받기", for: .normal)
        button.setTitleColor(.setColor(.white), for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.titleLabel?.font = .pretendardFont(size: 14, style: .semiBold)
        button.backgroundColor = .setColor(.gray100)
        return button
    }()
    
    private let smsNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "인증번호 5자리를 입력해주세요.(3분 이내)"
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 17.0, height: 0.0))
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor.setColor(.gray100).cgColor
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.keyboardType = .numberPad
        textField.tintColor = .setColor(.gray900)
        textField.textColor = .setColor(.gray900)
        textField.font = .pretendardFont(size: 13, style: .regular)
        return textField
    }()
    
    private let authStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 71.0))
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
        button.backgroundColor = .setColor(.gray100)
        button.isEnabled = false
        return button
    }()
    
    private let accessoryStackView: UIStackView = {
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
        phoneNumberTextField.delegate = self
        smsNumberTextField.delegate = self
    }
    
    private func configureButtonAction() {
        authNumberButton.addAction(UIAction(handler: tappedAuthNumberButton), for: .touchUpInside)
        confirmButton.addAction(UIAction(handler: tappedConfirmButton), for: .touchUpInside)
    }
    
    private func tappedAuthNumberButton(_ action: UIAction) {
        smsNumberTextField.isHidden = false
        smsNumberTextField.becomeFirstResponder()
        viewModel.action(.tapAuthNumber(phoneNumber: phoneNumberTextField.text))
    }
    
    private func tappedConfirmButton(_ action: UIAction) {
        guard let text = smsNumberTextField.text else { return }
        
        viewModel.action(.confirm(userInput: text))
    }
}

// MARK: - UI Components
extension LoginViewController {
    private func configureUI() {
        [welcomeLabel, authStackView].forEach(view.addSubview)
        [phoneNumberTextField, authNumberButton, smsNumberTextField].forEach(authStackView.addArrangedSubview)
        [privacyButton, dotLabel, userAgreeButton].forEach(accessoryStackView.addArrangedSubview)
        [accessoryStackView, confirmButton].forEach(accessoryView.addSubview)
        
        smsNumberTextField.isHidden = true
        phoneNumberTextField.becomeFirstResponder()
        smsNumberTextField.inputAccessoryView = accessoryView
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(6)
            $0.leading.equalTo(safeArea.snp.leading).offset(22)
        }
        
        authNumberButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        smsNumberTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        authStackView.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(19)
            $0.leading.equalTo(safeArea.snp.leading).offset(16)
            $0.trailing.equalTo(safeArea.snp.trailing).offset(-16)
        }
        
        accessoryStackView.snp.makeConstraints {
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

// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    func enableAuthButton() {
        authNumberButton.backgroundColor = .setColor(.basicBlack)
        authNumberButton.isEnabled = true
    }
    
    func disableAuthButton() {
        authNumberButton.backgroundColor = .setColor(.gray100)
        authNumberButton.isEnabled = false
    }
    
    func confirm(_ result: Bool) {
        if result == true {
            // 다음화면 푸시
        } else {
            // 인증번호가 틀립니다 얼럿
        }
    
    func enableConfirmButton() {
        confirmButton.backgroundColor = .setColor(.basicRed)
        confirmButton.isEnabled = true
    }
    
    func disableConfirmButton() {
        confirmButton.backgroundColor = .setColor(.gray100)
        confirmButton.isEnabled = false
    }
    
    func loginSuccessful() {
        // 로그인 성공. 다음 화면 푸시
    }
    
    func loginFailed() {
        // 로그인 실패. 사용자에게 알림
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            return viewModel.checkPhoneNumber(changedRange: range, replacedNumber: string)
        } else {
            return viewModel.checkAuthNumber(changedRange: range, replacedNumber: string)
        }
    }
}


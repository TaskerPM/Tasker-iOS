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
        label.text = "안녕하세요!\n휴대폰 번호를 입력해주세요."
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
    
    private let phoneNumberErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .setColor(.error)
        label.font = .pretendardFont(size: 11, style: .regular)
        label.isHidden = true
        label.text = "*11자리 모두 입력해주세요."
        return label
    }()
    
    private let requestAuthButton: RequestAuthButton = {
        let button = RequestAuthButton()
        button.initButton(isActive: false)
        return button
    }()
    
    private let authNumberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isHidden = true
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.layer.borderColor = UIColor.setColor(.gray100).cgColor
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 1
        return stackView
    }()
    
    private let authNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "인증번호 5자리를 입력해주세요.(3분 이내)"
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 17.0, height: 0.0))
        textField.leftViewMode = .always
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.tintColor = .setColor(.gray900)
        textField.textColor = .setColor(.gray900)
        textField.font = .pretendardFont(size: 13, style: .regular)
        return textField
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .setColor(.basicRed)
        label.font = .pretendardFont(size: 12, style: .regular)
        return label
    }()
    
    private let authNumberErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .setColor(.error)
        label.font = .pretendardFont(size: 11, style: .regular)
        label.isHidden = true
        label.text = "*인증번호를 다시 입력해주세요."
        return label
    }()
    
    private let accessoryView: UIView = {
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 80.0))
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
    
    private let userAgreementButton: UIButton = {
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
        authNumberTextField.delegate = self
    }
    
    private func configureButtonAction() {
        requestAuthButton.addAction(UIAction(handler: tappedAuthNumberButton), for: .touchUpInside)
        confirmButton.addAction(UIAction(handler: tappedConfirmButton), for: .touchUpInside)
        privacyButton.addAction(UIAction(handler: tappedPrivacyButton), for: .touchUpInside)
        userAgreementButton.addAction(UIAction(handler: tappedUserAgreementButton), for: .touchUpInside)
    }
    
    private func tappedAuthNumberButton(_ action: UIAction) {
        viewModel.action(.tapAuthNumber(phoneNumber: phoneNumberTextField.text))
    }
    
    private func tappedConfirmButton(_ action: UIAction) {
        viewModel.action(.checkCorrect(userInput: authNumberTextField.text))
    }
    
    private func tappedPrivacyButton(_ action: UIAction) {
        let webVC = WebViewController(linkString: "https://www.naver.com")
//        self.navigationController?.pushViewController(webVC, animated: true)
        self.present(webVC, animated: true)
    }
    
    private func tappedUserAgreementButton(_ action: UIAction) {
        let webVC = WebViewController(linkString: "https://www.google.com")
//        self.navigationController?.pushViewController(webVC, animated: true)
        self.present(webVC, animated: true)
    }
}

// MARK: - UI Components
extension LoginViewController {
    private func configureUI() {
        [authNumberTextField, timerLabel]
            .forEach(authNumberStackView.addArrangedSubview)
        
        [welcomeLabel, phoneNumberTextField, phoneNumberErrorLabel, requestAuthButton, authNumberStackView, authNumberErrorLabel]
            .forEach(view.addSubview)

        [privacyButton, dotLabel, userAgreementButton]
            .forEach(accessoryStackView.addArrangedSubview)
        
        [accessoryStackView, confirmButton]
            .forEach(accessoryView.addSubview)
        
        phoneNumberTextField.becomeFirstResponder()
        authNumberTextField.inputAccessoryView = accessoryView
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(6)
            $0.leading.equalTo(safeArea.snp.leading).offset(22)
        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(19)
            $0.leading.equalTo(safeArea.snp.leading).offset(16)
            $0.trailing.equalTo(safeArea.snp.trailing).inset(16)
            $0.height.equalTo(48)
        }
        
        phoneNumberErrorLabel.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(5)
            $0.leading.equalTo(phoneNumberTextField.snp.leading).offset(7)
        }
        
        authNumberStackView.snp.makeConstraints {
            $0.top.equalTo(requestAuthButton.snp.bottom).offset(8)
            $0.leading.equalTo(requestAuthButton.snp.leading)
            $0.trailing.equalTo(requestAuthButton.snp.trailing)
            $0.height.equalTo(48)
        }
        
        requestAuthButton.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(8)
            $0.leading.equalTo(phoneNumberTextField.snp.leading)
            $0.trailing.equalTo(phoneNumberTextField.snp.trailing)
            $0.height.equalTo(48)
        }
        
        authNumberErrorLabel.snp.makeConstraints {
            $0.top.equalTo(authNumberTextField.snp.bottom).offset(5)
            $0.leading.equalTo(authNumberTextField.snp.leading).offset(7)
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
    
    private func configurePhoneNumberErrorLabelLayout() {
        requestAuthButton.snp.remakeConstraints {
            if phoneNumberErrorLabel.isHidden {
                $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(8)
            } else {
                $0.top.equalTo(phoneNumberErrorLabel.snp.bottom).offset(10)
            }
            $0.leading.equalTo(phoneNumberTextField.snp.leading)
            $0.trailing.equalTo(phoneNumberTextField.snp.trailing)
            $0.height.equalTo(48)
        }
    }
}

// MARK: - LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    func enableAuthButton() {
        requestAuthButton.changeState(.active)
        phoneNumberErrorLabel.isHidden = true
        configurePhoneNumberErrorLabelLayout()
    }
    
    func disableAuthButton() {
        requestAuthButton.changeState(.inactive)
        phoneNumberErrorLabel.isHidden = false
        configurePhoneNumberErrorLabelLayout()
    }
    
    func receiveAuthNumberSuccessful(remainCount: Int) {
        DispatchQueue.main.async {
            self.authNumberStackView.isHidden = false
            self.authNumberTextField.text = ""
            self.authNumberTextField.becomeFirstResponder()
            self.authNumberErrorLabel.isHidden = true
            
            self.requestAuthButton.changeState(.redemanded, remainCount: remainCount)
        }
    }
    
    func receiveAuthNumberFailed(errorMessage: String) {
        let alert = AlertBuilder()
            .withTitle("오류")
            .withMessage("잠시후 다시 시도해주세요.\n\(errorMessage)")
            .withDefaultActions()
            .build()
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func enableConfirmButton() {
        confirmButton.backgroundColor = .setColor(.basicRed)
        confirmButton.isEnabled = true
        authNumberErrorLabel.isHidden = true
    }
    
    func disableConfirmButton() {
        confirmButton.backgroundColor = .setColor(.gray100)
        confirmButton.isEnabled = false
        authNumberErrorLabel.isHidden = true
    }
    
    func loginSuccessful() {
        // 로그인 성공. 다음 화면 푸시
    }
    
    func loginFailed() {
        self.authNumberErrorLabel.text = "*인증번호를 다시 입력해주세요."
        self.authNumberErrorLabel.isHidden = false
        
    }
    
    func updateTimerText(_ time: String) {
        DispatchQueue.main.async {
            self.timerLabel.text = time
        }
    }
    
    func expiredAuthTime() {
        DispatchQueue.main.async {
            self.authNumberErrorLabel.text = "*3분이 경과되었습니다. 인증번호를 다시 받아주세요."
            self.confirmButton.backgroundColor = .setColor(.gray100)
            self.confirmButton.isEnabled = false
            self.authNumberErrorLabel.isHidden = false
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            return viewModel.checkPhoneNumber(currentNumber: textField.text ,changedRange: range, replacedNumber: string)
        } else {
            return viewModel.checkAuthNumber(currentNumber: textField.text ,changedRange: range, replacedNumber: string)
        }
    }
}


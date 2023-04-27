//
//  LoginViewModel.swift
//  Tasker-iOS
//
//  Created by mingmac, Wonbi on 2023/04/19.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func enableAuthButton()
    func disableAuthButton()
    func receiveAuthNumberSuccessful()
    func receiveAuthNumberFailed(errorMessage: String)
    func enableConfirmButton()
    func disableConfirmButton()
    func loginSuccessful()
    func loginFailed()
}

final class LoginViewModel {
    enum Action {
        case tapAuthNumber(phoneNumber: String?)
        case checkCorrect(userInput: String?)
    }
    
    private let service = LoginService()
    private var authKey: String?
    private weak var delegate: LoginViewModelDelegate?
    
    func action(_ action: Action) {
        switch action {
        case .tapAuthNumber(let number):
            tapAuthNumber(number)
        case .checkCorrect(let userInput):
            checkCorrect(userInput)
        }
    }
    
    func setDelegate(_ delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
    
    func checkPhoneNumber(changedRange: NSRange, replacedNumber: String) -> Bool {
        guard replacedNumber.isEmpty || Int(replacedNumber) != nil else { return false }
        
        if changedRange.length != 0, changedRange.location == 11 {
            delegate?.enableAuthButton()
        } else if changedRange.length == 0, (changedRange.location + replacedNumber.count) == 11 {
            delegate?.enableAuthButton()
        } else {
            delegate?.disableAuthButton()
        }
        
        return true
    }
    
    func checkAuthNumber(changedRange: NSRange, replacedNumber: String) -> Bool {
        guard replacedNumber.isEmpty || Int(replacedNumber) != nil else { return false }
        
        if changedRange.length != 0, changedRange.location == 5 {
            delegate?.enableConfirmButton()
        } else if changedRange.length == 0, (changedRange.location + replacedNumber.count) == 5 {
            delegate?.enableConfirmButton()
        } else {
            delegate?.disableConfirmButton()
        }
        
        return true
    }
    
    private func tapAuthNumber(_ number: String?) {
        guard let number else { return }
        
        service.requestLogin(phoneNumber: number) { [weak self] result in
            switch result {
            case .success(let loginResponse):
                if let message = loginResponse.message {
                    print(message)
                    self?.delegate?.receiveAuthNumberFailed(errorMessage: message)
                    return
                }
                
                self?.authKey = loginResponse.value
                self?.delegate?.receiveAuthNumberSuccessful()
                
            case .failure(let error):
                self?.delegate?.receiveAuthNumberFailed(errorMessage: error.errorDescription)
            }
        }
    }
    
    private func checkCorrect(_ userInput: String?) {
        guard let userInput else { return }
        
        authKey == userInput ? delegate?.loginSuccessful() : delegate?.loginFailed()
    }
}

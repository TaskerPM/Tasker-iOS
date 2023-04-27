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
    func enableConfirmButton()
    func disableConfirmButton()
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
        case .confirm(let number):
            confirm(number)
        case .endEditing(let changedRange, let replacedNumber):
            checkPhoneNumber(range: changedRange, replacedNumber: replacedNumber)
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
    
    private func tapAuthNumber(_ number: String) {
        service.requestLogin(phoneNumber: number) { result in
            switch result {
            case .success(let loginResponse):
                
                if let message = loginResponse.message {
                    print(message)
                }
                
                self.authKey = loginResponse.value
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    private func confirm(_ userNumber: String) {
        delegate?.confirm(authKey == userNumber)
    }
}

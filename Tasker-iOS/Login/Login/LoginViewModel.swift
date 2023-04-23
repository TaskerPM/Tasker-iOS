//
//  LoginViewModel.swift
//  Tasker-iOS
//
//  Created by mingmac, Wonbi on 2023/04/19.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func confirm(_ result: Bool)
}

final class LoginViewModel {
    enum Action {
        case tapAuthNumber(phoneNumber: String)
        case confirm(userInput: String)
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
        }
    }
    
    func setDelegate(_ delegate: LoginViewModelDelegate) {
        self.delegate = delegate
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

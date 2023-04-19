//
//  LoginViewModel.swift
//  Tasker-iOS
//
//  Created by mingmac, Wonbi on 2023/04/19.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func getAuthKey()
    func confirm(_ result: Bool)
}

final class LoginViewModel {
    enum Action {
        case tapAuthNumber(phoneNumber: String)
        case confirm(userInput: String)
    }
    
    private let service = LoginService()
    private weak var delegate: LoginViewModelDelegate?
    
    private var authKey: String? {
        didSet {
            delegate?.getAuthKey()
        }
    }
    
    func action(_ action: Action) {
        switch action {
        case .tapAuthNumber(let number):
            tapAuthNumber(number)
        case .confirm(let number):
            confirm(number)
        }
    }
    
    private func tapAuthNumber(_ number: String) {
        service.login(phoneNumber: number) { result in
            switch result {
            case .success(let key):
                self.authKey = key.value
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    private func confirm(_ userNumber: String) {
        delegate?.confirm(authKey == userNumber)
    }
}

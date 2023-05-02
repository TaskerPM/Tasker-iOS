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
    func updateTimerText(_ time: String)
}

final class LoginViewModel {
    enum Action {
        case tapAuthNumber(phoneNumber: String?)
        case checkCorrect(userInput: String?)
    }
    
    private let service = LoginService()
    private var authKey: String?
    private weak var delegate: LoginViewModelDelegate?
    private var timer: Timer?
    private var timeLeft = 180 {
        didSet {
            delegate?.updateTimerText(timeToString(timeLeft))
        }
    }
    
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
    
    func checkPhoneNumber(currentNumber: String?, changedRange: NSRange, replacedNumber: String) -> Bool {
        guard let currentNumber,
              (replacedNumber.isEmpty || Int(replacedNumber) != nil),
              (currentNumber + replacedNumber).count <= 11
        else {
            return false
        }
        
        if changedRange.length != 0, changedRange.location == 11 {
            delegate?.enableAuthButton()
        } else if changedRange.length == 0, (changedRange.location + replacedNumber.count) == 11 {
            delegate?.enableAuthButton()
        } else {
            delegate?.disableAuthButton()
        }
        
        return true
    }
    
    func checkAuthNumber(currentNumber: String?, changedRange: NSRange, replacedNumber: String) -> Bool {
        guard let currentNumber,
              (replacedNumber.isEmpty || Int(replacedNumber) != nil),
              (currentNumber + replacedNumber).count <= 5
        else {
            return false
        }
        
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
                self?.startTimer()
                
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

extension LoginViewModel {
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeLeft > 0 {
                self.timeLeft -= 1
                print(self.timeLeft)
            } else {
                self.stopTimer()
            }
        }
        timer?.fire()
    }
    
    func stopTimer() {
        print("😝😝😝😝😝")
        timer?.invalidate()
        timer = nil
    }
    
    func timeToString(_ timeLeft: Int) -> String {
        let minutes: Int = timeLeft / 60
        let seconds: Int = timeLeft % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

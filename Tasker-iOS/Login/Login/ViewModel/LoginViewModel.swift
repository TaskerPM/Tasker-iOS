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
    func receiveAuthNumberSuccessful(remainCount: Int)
    func receiveAuthNumberFailed(errorMessage: String)
    func enableConfirmButton()
    func disableConfirmButton()
    func loginSuccessful()
    func loginFailed()
    func updateTimerText(_ time: String)
    func expiredAuthTime()
}

final class LoginViewModel {
    enum Action {
        case tapAuthNumber(phoneNumber: String?)
        case checkCorrect(userInput: String?)
    }
    
    private let service = LoginService()
    private var authKey: String?
    private weak var delegate: LoginViewModelDelegate?
    private var timer: ThreeMinuteTimer?
    
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
              (currentNumber + replacedNumber).count <= 5,
              authKey != nil
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
                print(loginResponse.message, "인증번호: \(loginResponse.value)")
                self?.stopTimer()
                self?.authKey = loginResponse.value
                // 서버에서 남은 횟수 받아와야 함 API 수정 필요
                self?.delegate?.receiveAuthNumberSuccessful(remainCount: 2)
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
    
    private func startTimer() {
        timer = ThreeMinuteTimer()
        
        timer?.start() { timeLeft in
            if timeLeft >= 0 {
                self.delegate?.updateTimerText(self.timeToString(timeLeft))
            }
        } completion: {
            self.stopTimer()
            
            self.delegate?.expiredAuthTime()
        }
    }
    
    private func stopTimer() {
        timer?.stop()
        
        authKey = nil
        timer = nil
    }
    
    private func timeToString(_ time: Int) -> String {
        let minutes: Int = time / 60
        let seconds: Int = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

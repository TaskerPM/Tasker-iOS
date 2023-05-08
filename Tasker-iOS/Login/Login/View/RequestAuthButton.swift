//
//  RequestAuthButton.swift
//  Tasker-iOS
//
//  Created by Wonbi on 2023/05/05.
//

import UIKit

final class RequestAuthButton: UIButton {
    enum State {
        case inactive
        case active
        case redemanded
        case expired
    }
    
    private var currentState: State = .inactive
    
    override init(frame: CGRect = CGRect(origin: CGPoint(), size: CGSize())) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState(_ state: State, remainCount: Int = 0, remainTime: Int = 0) {
        switch state {
        case .inactive:
            makeInactive()
        case .active:
            makeActive()
        case .redemanded:
            makeRedemanded(remainCount: remainCount)
        case .expired:
            makeExpired(remainTime: remainTime)
        }
    }
    
    func initButton(isActive: Bool) {
        initButton()
        
        if isActive {
            currentState = .inactive
            makeActive()
        } else {
            currentState = .active
            makeInactive()
        }
    }
    
    private func initButton() {
        self.setTitle("인증번호 받기", for: .normal)
        self.setTitleColor(.setColor(.white), for: .normal)
        self.layer.cornerRadius = 10
        self.isEnabled = false
        self.titleLabel?.font = .pretendardFont(size: 14, style: .semiBold)
        self.backgroundColor = .setColor(.gray100)
    }
    
    private func makeInactive() {
        guard currentState == .active else { return }
        currentState = .inactive
        
        self.isEnabled = false
        self.backgroundColor = .setColor(.gray100)
    }
    
    private func makeActive() {
        guard currentState == .inactive else { return }
        currentState = .active
        
        self.isEnabled = true
        self.backgroundColor = .setColor(.basicBlack)
    }
    
    private func makeRedemanded(remainCount: Int) {
        currentState = .redemanded
        
        self.setTitle("인증번호 다시 받기(\(remainCount)회 남음)", for: .normal)
        self.setTitleColor(.setColor(.gray300), for: .normal)
        self.backgroundColor = .white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.setColor(.gray300).cgColor
    }
    
    private func makeExpired(remainTime: Int) {
        guard currentState == .redemanded else { return }
        currentState = .expired
        let time: String = remainTime == 60 ? "1시간" : "\(remainTime)분"
        
        self.setTitle("시도 횟수가 초과되었습니다. \(time) 후 다시 시도해주세요.", for: .normal)
        self.setTitleColor(.setColor(.gray300), for: .normal)
        self.backgroundColor = .white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.setColor(.gray300).cgColor
    }
}

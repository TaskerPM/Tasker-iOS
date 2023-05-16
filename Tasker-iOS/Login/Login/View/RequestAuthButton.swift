//
//  RequestAuthButton.swift
//  Tasker-iOS
//
//  Created by Wonbi on 2023/05/05.
//

import UIKit

final class RequestAuthButton: UIButton {
    enum State: Equatable {
        case inactive
        case active
        case redemanded(count: Int)
        case expired(time: Int)
    }
    
    private var currentState: State = .inactive
    
    override init(frame: CGRect = CGRect(origin: CGPoint(), size: CGSize())) {
        super.init(frame: frame)
        initToRequest(isActive: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState(_ state: State) {
        switch state {
        case .inactive:
            makeInactive()
        case .active:
            makeActive()
        case .redemanded(let remainCount):
            makeRedemanded(remainCount: remainCount)
        case .expired(let remainTime):
            makeExpired(remainTime: remainTime)
        }
    }
    
    private func initToRequest(isActive: Bool) {
        self.setTitle("인증번호 받기", for: .normal)
        self.setTitleColor(.setColor(.white), for: .normal)
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 10
        self.isEnabled = isActive ? true : false
        self.titleLabel?.font = .pretendardFont(size: 14, style: .semiBold)
        self.backgroundColor = isActive ? .setColor(.basicBlack) : .setColor(.gray100)
    }
    
    private func initToConfirm() {
        self.setTitleColor(.setColor(.gray300), for: .normal)
        self.backgroundColor = .white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.setColor(.gray300).cgColor
    }
    
    private func makeInactive() {
        if currentState == .active {
            self.isEnabled = false
            self.backgroundColor = .setColor(.gray100)
        } else {
            initToRequest(isActive: false)
        }
        
        currentState = .inactive
    }
    
    private func makeActive() {
        if currentState == .inactive {
            self.isEnabled = true
            self.backgroundColor = .setColor(.basicBlack)
        } else {
            initToRequest(isActive: true)
        }
        
        currentState = .active
    }
    
    private func makeRedemanded(remainCount: Int) {
        currentState = .redemanded(count: remainCount)
        
        initToConfirm()
        self.setTitle("인증번호 다시 받기(\(remainCount)회 남음)", for: .normal)
    }
    
    private func makeExpired(remainTime: Int) {
        currentState = .expired(time: remainTime)
        let time: String = remainTime == 60 ? "1시간" : "\(remainTime)분"
        
        initToConfirm()
        self.setTitle("시도 횟수가 초과되었습니다. \(time) 후 다시 시도해주세요.", for: .normal)
    }
}

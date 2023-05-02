//
//  Timer.swift
//  Tasker-iOS
//
//  Created by Wonbi on 2023/05/02.
//

import Foundation

protocol RepeatingSecondsTimer {
    func start(repeatingExecution: ((Int) -> Void)?, completion: (() -> Void)?)
    func stop()
}

final class ThreeMinuteTimer: RepeatingSecondsTimer {
    private var timeLeft: Int = 180
    private var repeatingExecution: ((Int) -> Void)?
    private var completion: (() -> Void)?
    private var timers: (repeatTimer: DispatchSourceTimer?, nonRepeatTimer: DispatchSourceTimer?) = (DispatchSource.makeTimerSource(),
                                                                                                     DispatchSource.makeTimerSource())
    
    deinit {
        stop()
    }
    
    func start(repeatingExecution: ((Int) -> Void)? = nil, completion: (() -> Void)? = nil) {
        setTimer(repeatingExecution: repeatingExecution, completion: completion)
        
        resume()
    }
    
    func stop() {
        timers.repeatTimer?.cancel()
        timers.nonRepeatTimer?.cancel()
        
        initTimer()
    }
    
    private func resume() {
        timers.repeatTimer?.resume()
        timers.nonRepeatTimer?.resume()
    }
    
    private func initTimer() {
        timers.repeatTimer?.setEventHandler(handler: nil)
        timers.nonRepeatTimer?.setEventHandler(handler: nil)

        repeatingExecution = nil
        completion = nil
        timeLeft = 180
    }
    
    private func setTimer(repeatingExecution: ((Int) -> Void)? = nil, completion: (() -> Void)? = nil) {
        initTimer()
        
        self.repeatingExecution = repeatingExecution
        self.completion = completion
        
        timers.repeatTimer?.schedule(deadline: .now(), repeating: 1)
        timers.repeatTimer?.setEventHandler {
            self.timeLeft -= 1
            self.repeatingExecution?(self.timeLeft)
        }
        
        timers.nonRepeatTimer?.schedule(deadline: .now() + 180)
        timers.nonRepeatTimer?.setEventHandler { [weak self] in
            self?.initTimer()
            completion?()
        }
    }
}

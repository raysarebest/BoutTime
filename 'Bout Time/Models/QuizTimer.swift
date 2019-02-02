//
//  QuizTimer.swift
//  'Bout Time
//
//  Created by Michael Hulet on 12/10/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import Foundation

class QuizTimer{ // I wanna subclass `Timer` here instead of maintain my own internal timer, but the documentation says I shouldn't :(

    // MARK: - Properties

    private(set) var remainingSeconds: TimeInterval
    private(set) var running = true
    private var shouldStop = false

    // MARK: - Initializers

    init(seconds: TimeInterval, countdownHandler: @escaping (TimeInterval) -> Void){
        remainingSeconds = seconds
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer: Timer) in
            guard self.remainingSeconds >= 0 && !self.shouldStop else{
                timer.invalidate()
                return
            }
            self.remainingSeconds -= 1
            countdownHandler(self.remainingSeconds)
        })
    }

    // MARK: - Countdown Management

    func stop(){
        shouldStop = true
        running = false
    }
}

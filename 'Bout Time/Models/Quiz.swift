//
//  Quiz.swift
//  'Bout Time
//
//  Created by Michael Hulet on 12/6/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import Foundation
import UIKit // I hate importing UIKit into my models, but I'm doing it strictly for access to the UIApplication.didReceiveMemoryWarningNotification symbol so I can handle the eventCache based on memory pressure

private var eventCache: [Event]? = nil

protocol QuizDelegate: class{
    func timerDidTick(for question: Question, remainingSeconds: TimeInterval, quiz: Quiz)
    func timerDidExpire(for question: Question, correctOrder: [Event], quiz: Quiz)
}

class Quiz{

    // MARK:  General Default Configuration

    private static let minQuestionEventCount = 4
    private static var allEvents: [Event] = {
        if let cache = eventCache{
            return cache
        }
        else{
            let fileName = "Events"
            let fileType = "plist"
            guard let path = Bundle.main.path(forResource: fileName, ofType: fileType) else{
                fatalError("Could not find file \"\(fileName).\(fileType)\" in main bundle")
            }

            do{
                let rawData = try Data(contentsOf: URL(fileURLWithPath: path))
                let events = try PropertyListDecoder().decode([Event].self, from: rawData)

                guard events.count > Quiz.minQuestionEventCount else{
                    fatalError("Too few events were found. \(Quiz.minQuestionEventCount) are required, but \(events.count) were found")
                }

                return events
            }
            catch{
                print(error.localizedDescription)
                fatalError("Error parsing question list: " + error.localizedDescription)
            }
        }
    }()

    var secondsPerQuestion: TimeInterval = 60

    // MARK: - Question Management
    
    private(set) var questions = [Question]()
    private var currentQuestionIndex = 0
    var currentQuestion: Question?{
        get{
            guard currentQuestionIndex < questions.count else{
                return nil
            }
            return questions[currentQuestionIndex]
        }
        set{
            if let new = newValue{
                questions[currentQuestionIndex] = new
            }
        }
    }
    var previousQuestion: Question?{
        if case 1...questions.count = currentQuestionIndex{
            return questions[currentQuestionIndex - 1]
        }
        else{
            return nil
        }
    }

    private(set) var score = 0

    // MARK: - Timing

    weak var delegate: QuizDelegate?
    private var timer: QuizTimer?

    enum Error: Swift.Error{
        case quizComplete
        case untimed
    }

    func answerCurrentQuestion() throws -> Bool{
        guard let countdown = timer, countdown.running else{
            throw Error.untimed
        }
        stopTimer()
        guard let question = currentQuestion else{
            throw Error.quizComplete
        }
        defer{
            currentQuestionIndex += 1
        }
        if question.isOrdered{
            score += 1
        }
        return question.isOrdered
    }

    func startTimer(){
        timer = QuizTimer(seconds: secondsPerQuestion, countdownHandler: {(remainingSeconds: TimeInterval) in
            guard let question = self.currentQuestion else{
                self.timer?.stop()
                return
            }

            self.delegate?.timerDidTick(for: question, remainingSeconds: remainingSeconds, quiz: self)

            if remainingSeconds == 0{
                self.delegate?.timerDidExpire(for: question, correctOrder: question.events.sorted(), quiz: self)
                let _ = try? self.answerCurrentQuestion() // Error handling happens in the delegate, but it should be impossible for an error to occur here
                self.stopTimer()
            }
        })
    }

    private func stopTimer(){
        timer?.stop()
        timer = nil
    }

    // MARK: - Lifecycle Management

    init(questionCount: UInt = 6){
        for _ in 1...questionCount{
            questions.append(Question(events: Quiz.allEvents.shuffled()[0..<Quiz.minQuestionEventCount]))
        }
        NotificationCenter.default.addObserver(self, selector: #selector(clearEventCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }

    convenience init<Integer: BinaryInteger>(questionCount: Integer){
        self.init(questionCount: UInt(questionCount.absoluteValue))
    }

    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func clearEventCache(){
        eventCache = nil
    }
}

extension BinaryInteger{
    var absoluteValue: Self{
        get{
            return Self.isSigned ? max(self, self * -1) : self
        }
    }
}

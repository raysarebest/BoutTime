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
                let events = try PropertyListDecoder().decode([Event].self, from: try Data(contentsOf: URL(fileURLWithPath: path)))

                if events.count < Quiz.minQuestionEventCount{
                    fatalError("Too few events were found. \(Quiz.minQuestionEventCount) are required, but \(events.count) were found")
                }
                else{
                    return events
                }
            }
            catch{
                fatalError("Error parsing question list: " + error.localizedDescription)
            }
        }
    }()
    private(set) var questions = [Question]()
    private var currentQuestionIndex = 0
    var currentQuestion: Question?{
        get{
            guard currentQuestionIndex < questions.count else{
                return nil
            }
            return questions[currentQuestionIndex]
        }
    }
    weak var delegate: QuizDelegate?
    private var timer: QuizTimer?

    init(questionCount: UInt = 6){
        for _ in 1...questionCount{
            questions.append(Question(events: Quiz.allEvents.shuffled()[0..<Quiz.minQuestionEventCount]))
        }
        NotificationCenter.default.addObserver(self, selector: #selector(clearEventCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }

    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    convenience init<Integer: BinaryInteger>(questionCount: Integer){
        self.init(questionCount: UInt(questionCount.absoluteValue))
    }

    enum Error: Swift.Error{
        case quizComplete
        case untimed
    }

    func answerCurrentQuestion() throws -> Bool{
        guard let countdown = timer, countdown.running else{
            throw Error.untimed
        }
        guard let question = currentQuestion else{
            throw Error.quizComplete
        }
        currentQuestionIndex += 1
        return question.isOrdered
    }

    func startTimer() -> Void{
        timer = QuizTimer(countdownHandler: {(remainingSeconds: TimeInterval) in
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

    private func stopTimer() -> Void{
        timer?.stop()
        timer = nil
    }

    @objc private func clearEventCache() -> Void{
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

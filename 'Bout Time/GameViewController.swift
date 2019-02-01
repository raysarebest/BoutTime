//
//  GameViewController.swift
//  'Bout Time
//
//  Created by Michael Hulet on 11/30/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import UIKit
import SafariServices

class GameViewController: UIViewController, QuizDelegate{
    var trivia: Quiz?{
        didSet{
            trivia?.delegate = self
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }

    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var eventsStackView: UIStackView!
    @IBOutlet var reorderingButtons: [ReorderingButton]!
    var eventViews: [EventView]{
        get{
            guard let views = eventsStackView.arrangedSubviews as? [EventView] else{
                fatalError("Not every arranged subview is an EventView. Investigate in Interface Builder")
            }
            return views
        }
    }

    override func viewWillAppear(_ animated: Bool) -> Void{
        super.viewWillAppear(animated)
        if trivia == nil{
            trivia = Quiz()
            layoutNextQuestion()
        }
    }

    override func viewDidAppear(_ animated: Bool) -> Void{
        super.viewDidAppear(animated)
        if let quiz = trivia, let question = quiz.currentQuestion, let first = quiz.questions.first, question == first{
            quiz.startTimer()
        }
    }

    @IBAction func reorder(_ sender: ReorderingButton) -> Void{
        trivia?.currentQuestion?.reorder(index: sender.index, direction: sender.reorderDirection)
        layoutEventsForCurrentQuestion()
    }

    func layout(events: [Event]) -> Void{
        for (eventView, event) in zip(eventViews, events){
            eventView.eventLabel.text = event.title
        }
    }

    func layoutEventsForCurrentQuestion() -> Void{
        guard let question = trivia?.currentQuestion else{
            return
        }
        layout(events: question.events)
    }

    @IBAction func nextQuestion() -> Void{
        if trivia?.currentQuestion != nil{
            layoutNextQuestion()
            trivia?.startTimer()
        }
        else if let quiz = trivia, let playAgainController = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: "Play Again") as? PlayAgainViewController{
            playAgainController.score = quiz.score
            playAgainController.totalQuestions = quiz.questions.count
            trivia = nil
            present(playAgainController, animated: false, completion: nil)
        }
    }

    func layoutNextQuestion() -> Void{
        guard let quiz = trivia else{
            return
        }
        layoutEventsForCurrentQuestion()
        updateTimer(remainingSeconds: quiz.secondsPerQuestion)
        infoLabel.text = "Shake to Complete"

        countdownLabel.isHidden = false
        nextRoundButton.isHidden = true

        for button in reorderingButtons{
            button.isEnabled = true
        }

        for event in eventsStackView.arrangedSubviews{
            guard let recognizers = event.gestureRecognizers else{
                continue
            }
            for recognizer in recognizers{
                event.removeGestureRecognizer(recognizer)
            }
        }
    }

    func layoutForAnsweredQuestion(isCorrect: Bool, correctEventOrder: [Event] = []) -> Void{
        if !isCorrect{
            layout(events: correctEventOrder)
            GameSound.incorrectAnswer.play()
        }
        else{
            GameSound.correctAnswer.play()
        }

        for button in reorderingButtons{
            button.isEnabled = false
        }
        for event in eventsStackView.arrangedSubviews{
            event.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentInfoForEventViewTap(_:))))
        }

        nextRoundButton.setImage(isCorrect ? #imageLiteral(resourceName: "Next Round Button/correct") : #imageLiteral(resourceName: "Next Round Button/incorrect"), for: .normal)
        countdownLabel.isHidden = true
        nextRoundButton.isHidden = false
        infoLabel.text = "Tap events to learn more"
    }

    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) -> Void{
        guard motion == .motionShake, let quiz = trivia, let question = quiz.currentQuestion else{
            return
        }

        let correctOrder = question.events.sorted()
        guard let isCorrect = try? quiz.answerCurrentQuestion() else{
            return // This should realistically never happen
        }
        layoutForAnsweredQuestion(isCorrect: isCorrect, correctEventOrder: correctOrder)
    }

    func updateTimer(remainingSeconds: TimeInterval) -> Void{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        countdownLabel.text = formatter.string(from: remainingSeconds)
    }

    func timerDidTick(for question: Question, remainingSeconds: TimeInterval, quiz: Quiz) -> Void{
        updateTimer(remainingSeconds: remainingSeconds)
    }

    func timerDidExpire(for question: Question, correctOrder: [Event], quiz: Quiz) {
        layoutForAnsweredQuestion(isCorrect: question.isOrdered)
    }

    @objc func presentInfoForEventViewTap(_ sender: UITapGestureRecognizer) -> Void{
        guard let question = trivia?.lastQuestion, let tapped = sender.view, let index = eventsStackView.arrangedSubviews.firstIndex(of: tapped) else{
            return // This should realistically never happen
        }
        let browser = SFSafariViewController(url: question.events.sorted()[index].infoLink)
        browser.preferredBarTintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0.06666666667, alpha: 1)
        browser.preferredControlTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        browser.modalPresentationCapturesStatusBarAppearance = true
        browser.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        present(browser, animated: true, completion: nil)
    }
}

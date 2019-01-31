//
//  ViewController.swift
//  'Bout Time
//
//  Created by Michael Hulet on 11/30/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    var trivia = Quiz()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }

    @IBOutlet weak var eventsStackView: UIStackView!
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
        layoutForCurrentQuestion()
    }

    override func viewDidAppear(_ animated: Bool) -> Void{
        super.viewDidAppear(animated)
        trivia.startTimer()
    }

    @IBAction func reorder(_ sender: ReorderingButton) -> Void{
        trivia.currentQuestion?.reorder(index: sender.index, direction: sender.reorderDirection)
        layoutForCurrentQuestion()
    }

    func layoutForCurrentQuestion() -> Void{
        guard let question = trivia.currentQuestion else{
            return
        }
        for (eventView, event) in zip(eventViews, question.events){
            eventView.eventLabel.text = event.title
        }
    }
}

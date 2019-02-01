//
//  PlayAgainViewController.swift
//  'Bout Time
//
//  Created by Michael Hulet on 2/1/19.
//  Copyright © 2019 Michael Hulet. All rights reserved.
//

import UIKit

class PlayAgainViewController: UIViewController{
    @IBOutlet weak var scoreLabel: UILabel?
    var score = 0{
        didSet{
            displayScore()
        }
    }
    var totalQuestions = 0{
        didSet{
            displayScore()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }

    @IBAction func playAgain() -> Void{
        dismiss(animated: false, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) -> Void{
        super.viewWillAppear(animated)
        displayScore()
    }

    private func displayScore() -> Void{
        if let label = scoreLabel{
            label.text = "\(score)/\(totalQuestions)"
        }
    }
}

//
//  PlayAgainViewController.swift
//  'Bout Time
//
//  Created by Michael Hulet on 2/1/19.
//  Copyright © 2019 Michael Hulet. All rights reserved.
//

import UIKit

class PlayAgainViewController: UIViewController{

    // MARK: - Properties

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

    // MARK: - Actions

    @IBAction func playAgain(){
        dismiss(animated: false, completion: nil)
    }

    // MARK: - Appearance

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }

    // MARK: - Lifecycle Management

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        displayScore()
    }

    // MARK: - Helpers

    private func displayScore() -> Void{
        if let label = scoreLabel{
            label.text = "\(score)/\(totalQuestions)"
        }
    }
}

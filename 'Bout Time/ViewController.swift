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

    override func viewDidAppear(_ animated: Bool) -> Void{
        super.viewDidAppear(animated)
        trivia.startTimer()
    }
}

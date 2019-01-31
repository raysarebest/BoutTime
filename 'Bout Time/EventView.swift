//
//  EventView.swift
//  'Bout Time
//
//  Created by Michael Hulet on 1/30/19.
//  Copyright © 2019 Michael Hulet. All rights reserved.
//

import UIKit

class EventView: UIView {
    @IBOutlet var eventLabel: UILabel!
    override func layoutSubviews() -> Void{
        layer.cornerRadius = 5
        super.layoutSubviews()
    }
}

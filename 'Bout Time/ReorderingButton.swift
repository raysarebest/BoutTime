//
//  ReorderingButton.swift
//  'Bout Time
//
//  Created by Michael Hulet on 1/30/19.
//  Copyright © 2019 Michael Hulet. All rights reserved.
//

import UIKit

class ReorderingButton: UIButton {
    @IBInspectable var shouldReorderUpwards: Bool = true
    @IBInspectable var index: Int = 0 // This is currently set in Interface Builder, which is janky af, but I'm not programming for Google rn and it gets the job done
    var reorderDirection: Question.ReorderDirection{
        get{
            guard let direction = Question.ReorderDirection(rawValue: shouldReorderUpwards ? -1 : 1) else{
                fatalError("Could not construct reorder direction from raw value. Check to make sure the constants passed here match up with the defined raw values")
            }
            return direction
        }
    }
}

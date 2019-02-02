//
//  Event.swift
//  'Bout Time
//
//  Created by Michael Hulet on 12/2/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import Foundation
struct Event: Decodable, Hashable{
    let title: String
    let moment: Date
    let infoLink: URL
}

extension Event: Comparable{
    static func < (left: Event, right: Event) -> Bool{
        return left.moment < right.moment
    }
}

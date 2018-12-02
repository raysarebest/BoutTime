//
//  Question.swift
//  'Bout Time
//
//  Created by Michael Hulet on 12/2/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import Foundation

struct Question{
    var events = [Event](){
        didSet{
            let uniques = Set(events)
            if uniques.count != events.count{
                update(events: uniques)
            }
        }
    }
    var isOrdered: Bool{
        get{
            return events == events.sorted()
        }
    }

    init(events: [Event]){
        for event in events{
            add(event)
        }
    }

    init(events: Set<Event>){
        update(events: events)
    }

    mutating func add(_ event: Event) -> Void{
        var uniques = Set(events)
        uniques.insert(event)
        update(events: uniques)
    }

    private mutating func update(events: Set<Event>) -> Void{
        self.events = Array(events).shuffled()
    }
}

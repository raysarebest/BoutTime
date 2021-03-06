//
//  Question.swift
//  'Bout Time
//
//  Created by Michael Hulet on 12/2/18.
//  Copyright © 2018 Michael Hulet. All rights reserved.
//

import Foundation

struct Question: Equatable{
    private(set) var events = [Event](){
        didSet{
            let uniques = Set(events)
            if uniques.count != events.count{
                update(events: uniques)
            }
        }
    }

    // MARK: - Correctness Checking

    var isOrdered: Bool{
            return isOrdered(events: events)
    }

    func isOrdered(events local: [Event]) -> Bool{
        return local == events.sorted()
    }

    // MARK: - Initialization

    init<Collection: Sequence>(events: Collection) where Collection.Element == Event{
        update(events: Set(events))
    }

    init(events: Set<Event>){
        update(events: events)
    }

    private mutating func update(events: Set<Event>){
        self.events = Array(events).shuffled()
    }

    // MARK: - Event Reordering

    mutating func reorder(index: Int, direction: ReorderDirection){
        func isWithinValidRange(_ possibleIndex: Int) -> Bool{
            return 0..<events.count ~= index
        }
        guard isWithinValidRange(index) && isWithinValidRange(index + direction.rawValue) else{
            return
        }
        events.swapAt(index, index + direction.rawValue)
    }

    mutating func reorder(_ event: Event, direction: ReorderDirection) -> Void{
        guard let index = events.firstIndex(of: event) else{
            return
        }
        reorder(index: index, direction: direction)
    }

    @objc enum ReorderDirection: Int{
        case up = -1
        case down = 1
    }
}

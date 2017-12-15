//
//  BoutTime.swift
//  BoutTime
//
//  Created by Ehsan on 11/12/2017.
//  Copyright © 2017 Ali C. All rights reserved.
//

import Foundation
import GameKit

let eventsPerRound = 4

enum PlistError: Error {
    case invalidResource
    case conversionFailure
}

// Class with a type method to convert plist to dictionary of [String: Any]
class PlistConvertor {
    static func dictionary(fromFile name: String, ofType type: String) throws -> [String: Any] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw PlistError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            throw PlistError.conversionFailure
        }
        
        return dictionary
    }
}


protocol HistoricalEvent {
    var event: String { get }
    var year: Int { get }
}


class EventManager: HistoricalEvent {
    
    var event: String
    var year: Int
    
    init(event: String, year: Int) {
        self.event = event
        self.year = year
    }
    
    // Convert dictionary of [String: Any] to array of [HistoricalEvent]
    static func dictionaryUnarchiver(fromDictionary dictionary: [String: Any]) -> [HistoricalEvent]{
        var events: [HistoricalEvent] = []
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any], let year = itemDictionary["year"] as? Int {
                let historicalEvent = EventManager(event: key, year: year)
                events.append(historicalEvent)
            }
        }
        
        let organizedEvents = provideEvents(events)
        
        return organizedEvents
    }
    
}


// Helper function to divide the events in group of 4
func provideEvents(_ events: [HistoricalEvent]) -> [HistoricalEvent] {
    var organizedEvents: [HistoricalEvent] = []
    var copyOfEvents = events
    
    for _ in events {
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: copyOfEvents.count - 1)
        if organizedEvents.count < eventsPerRound {
            organizedEvents.append(copyOfEvents[randomNumber])
            copyOfEvents.remove(at: randomNumber)
        } else {
            return organizedEvents
        }
    }
    
    return organizedEvents
}


struct EventPack {
    
    let event1: HistoricalEvent
    let event2: HistoricalEvent
    let event3: HistoricalEvent
    let event4: HistoricalEvent
    
    // Helper function to populate the struct
    static func provideEventPack(_ organizedEvents: [HistoricalEvent]) -> EventPack {
        let eventPack = EventPack(event1: organizedEvents[0], event2: organizedEvents[1], event3: organizedEvents[2], event4: organizedEvents[3])
        
        return eventPack
    }

}






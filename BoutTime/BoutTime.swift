//
//  BoutTime.swift
//  BoutTime
//
//  Created by Ehsan on 11/12/2017.
//  Copyright © 2017 Ali C. All rights reserved.
//

import Foundation

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
    
    // Covert dictionary of [String: Any] to array of [HistoricalEvent]
    static func dictionaryUnarchiver(fromDictionary dictionary: [String: Any]) -> [HistoricalEvent]{
        var organizedEvents: [HistoricalEvent] = []
        
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any], let year = itemDictionary["year"] as? Int {
                let historicalEvent = EventManager(event: key, year: year)
                organizedEvents.append(historicalEvent)
            }
        }
        
        return organizedEvents
    }
}


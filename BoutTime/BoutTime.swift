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

// Class with a type method to convert plist to dictionary of [String: Int]
class PlistConvertor {
    static func dictionary(fromFile name: String, ofType type: String) throws -> [String: Int] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw PlistError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: Int] else {
            throw PlistError.conversionFailure
        }
        
        return dictionary
    }
}



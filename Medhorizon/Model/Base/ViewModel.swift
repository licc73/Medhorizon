//
//  ViewModel.swift
//  Medhorizon
//
//  Created by lich on 10/9/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

protocol ViewModel {
    static func mapToModel(dictionary: [String: AnyObject]) -> Self?
}

func mapToString(dictionary: [String: AnyObject]) -> String -> String? {
    return { key in
        if let value = dictionary[key] as? String {
            return value
        }
        return nil
    }
}

func mapToInt(dictionary: [String: AnyObject]) -> String -> Int? {
    return { key in
        let value = dictionary[key]
        if let value = value as? Int {
            return value
        }
        else if let value = value as? String, intValue = Int(value) {
            return intValue
        }
        
        return nil
    }
}

func mapToBool(dictionary: [String: AnyObject]) -> String -> Bool? {
    return { key in
        let value = dictionary[key]
        if let value = value as? Bool {
            return value
        }
        else if let value = value as? NSNumber {
            return value.boolValue
        }
        else if let value = value as? String {
            return value != "0"
        }
        return nil
    }
}

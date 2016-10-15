//
//  SomeExtension.swift
//  Medhorizon
//
//  Created by lichangchun on 10/15/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

extension String {
    var isValidPhone: Bool {
        let predicate = NSPredicate(format: "SELF MAtCHES %@", "^1\\d{10}$")
        return predicate.evaluateWithObject(self)
    }
}

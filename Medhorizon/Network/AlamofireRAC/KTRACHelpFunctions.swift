//
//  KTRACHelpFunctions.swift
//  Knuth
//
//  Created by ChenYong on 11/19/15.
//  Copyright © 2015 Autodesk. All rights reserved.
//

import Foundation
import ReactiveCocoa

public let tagErrorKey = "tag"

func optionalMapValue<T: AnyObject, U>(sp: SignalProducer<T, ServiceError>, c: T -> U? ) -> SignalProducer<U, ServiceError> {
    return sp.flatMap(FlattenStrategy.Latest) { (t) -> SignalProducer<U, ServiceError> in
        if let u = c(t) {
            return SignalProducer(value: u)
        } else {
            return SignalProducer(error: .OptionalMapError(ServerResponseType.from(t)))
        }
    }
}





public func justCast<T: AnyObject, U>(t: T) -> U? { return t as? U
}

infix  operator <~ {
    associativity left
    precedence 100
}

public func <~ <T: AnyObject, U>(sp: SignalProducer<T, ServiceError>, c: T -> U? ) -> SignalProducer<U, ServiceError> {
    return optionalMapValue(sp, c: c)
}

//
// FIXME: It seems if T is [String: AnyObject], Swift doesn't treat it as an AnyObject Type
//
func optionalMapValue2<U>(sp: SignalProducer<[String: AnyObject], ServiceError>, c: [String: AnyObject] -> U? ) -> SignalProducer<U, ServiceError> {
    return sp.flatMap(FlattenStrategy.Latest) { (t) -> SignalProducer<U, ServiceError> in
        if let u = c(t) {
            return SignalProducer(value: u)
        } else {
            return SignalProducer(error: .OptionalMapError(ServerResponseType.from(t)))
        }
    }
}

public func <~ <U>(sp: SignalProducer<[String: AnyObject], ServiceError>, c: [String: AnyObject] -> U? ) -> SignalProducer<U, ServiceError> { return optionalMapValue2(sp, c: c) }


public func tag<T, U: AnyObject>(tag: U, sp: SignalProducer<T, NSError>) -> SignalProducer<(value: T, tag: U), NSError> {
    return sp.map { ($0, tag)}
    .mapError { (error) -> NSError in
        var dict = error.userInfo ?? [NSObject: AnyObject]()
        dict[tagErrorKey] = tag
        return error
    }
}

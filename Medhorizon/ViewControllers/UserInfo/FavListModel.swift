//
//  FavListModel.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa

enum FavType: Int {
    case All = 0
    case News = 5
    case World = 6
    case Meeting = 7
    case Document = 8
}

enum FavOpType: Int {
    case Fav = 0
    case CancelFav = 1
}

func performFavOrCancel(userId: String, InfoId: String, type: FavOpType) -> SignalProducer<ReturnMsg?, ServiceError> {
    return DefaultServiceRequests.rac_requestForFavOrCancelFav(userId, infoId: InfoId, favType: type.rawValue)
        .map({ (object) -> ReturnMsg? in
            return ReturnMsg.mapToModel(object)
        })
}

func performGetFavStatus(userId: String, InfoId: String) -> SignalProducer<(ReturnMsg?, Bool), ServiceError> {
    return DefaultServiceRequests.rac_requesForGetFavStatus(userId, infoId: InfoId)
        .map({ (object) in
            let returnMsg = ReturnMsg.mapToModel(object)
            if let msg = returnMsg {
                if msg.isSuccess {
                    let b = mapToBool(object)("FState")
                    return (msg, b ?? false)
                }
                else {
                    return (msg, false)
                }
            }
            else {
                return (nil, false)
            }

        })
}

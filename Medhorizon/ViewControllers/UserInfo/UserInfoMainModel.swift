//
//  UserInfoMainModel.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

protocol TableViewCellHeight {
    var cellHeight: CGFloat {get}
}

struct UserInfoHeaderPicType: TableViewCellHeight {
    let picUrl: String?
    let nickName: String?
    let onlineDay: Int?
    let cellHeight: CGFloat
}

struct UserInfoBaseInfoType: TableViewCellHeight {
    let title: String
    let icon: String
    let titleColor: UIColor?
    let cellHeight: CGFloat
}

struct UserInfoSeparatorLineType: TableViewCellHeight {
    let color: UIColor?
    let insets: UIEdgeInsets?
    let lineHeight: CGFloat

    var cellHeight: CGFloat {
        return lineHeight
    }
}

enum UserMainInfoType {
    case None
    case Header(UserInfoHeaderPicType)
    case Msg(UserInfoBaseInfoType)
    case SeparatorLine(UserInfoSeparatorLineType)
    case PersonalInfo(UserInfoBaseInfoType)
    case Fav(UserInfoBaseInfoType)
    case Point(UserInfoBaseInfoType)
    case Download(UserInfoBaseInfoType)
    case Setting(UserInfoBaseInfoType)
    case Feedback(UserInfoBaseInfoType)
    case Logout

    var cellHeight: CGFloat {
        switch self {
        case .None:
            return 0
        case let .Header(header):
            return header.cellHeight
        case let .Msg(cellInfo):
            return cellInfo.cellHeight
        case let .SeparatorLine(cellInfo):
            return cellInfo.cellHeight
        case let .PersonalInfo(cellInfo):
            return cellInfo.cellHeight
        case let .Fav(cellInfo):
            return cellInfo.cellHeight
        case let .Point(cellInfo):
            return cellInfo.cellHeight
        case let .Download(cellInfo):
            return cellInfo.cellHeight
        case let .Setting(cellInfo):
            return cellInfo.cellHeight
        case let .Feedback(cellInfo):
            return cellInfo.cellHeight
        case .Logout:
            return 50
        }
    }

    var cellId: String {
        switch self {
        case .Header:
            return userHeaderTableViewCellId
        case .Msg:
            return msgTableViewCellId
        case .SeparatorLine:
            return separatorLineTableViewCellId
        default:
            return baseInfoTableViewCellId
        }
    }
}



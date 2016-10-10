//
//  BaseViewModel.swift
//  Medhorizon
//
//  Created by lich on 10/9/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

final class ReturnMsg {
    static let defaultSuccessReturnMsg = ReturnMsg(successFlag: "Y", errorMsg: "")
    
    let successFlag: String
    let errorMsg: String?
    
    init(successFlag: String, errorMsg: String?) {
        self.successFlag = successFlag
        self.errorMsg = errorMsg
    }
    
    var isSuccess: Bool {
        return self.successFlag.uppercaseString == "Y"
    }
}

extension ReturnMsg: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> ReturnMsg? {
        let stringMap = mapToString(dictionary)
        if let flag = stringMap("successFlag") {
            return ReturnMsg(successFlag: flag, errorMsg: stringMap("errorMsg"))
        }
        return nil
    }
    
}

final class Branner {
    let id: String
    let title: String?
    let linkUrl: String
    let picUrl: String?
    
    init(id: String, title: String?, linkUrl: String, picUrl: String?) {
        self.id = id
        self.title = title
        self.linkUrl = linkUrl
        self.picUrl = picUrl
    }
    
}

extension Branner: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> Branner? {
        let stringMap = mapToString(dictionary)
        if let id = stringMap("BrannerId"), linkUrl = stringMap("BrannerLinkUrl") {
            return Branner(id: id, title: stringMap("BrannerTitle"), linkUrl: linkUrl, picUrl: stringMap("BrannerPicUrl"))
        }
        return nil
    }
    
}

final class NewsViewModel {
    let id: String
    let title: String
    let keyWordInfo: String?
    let picUrl: String?
    let createdDate: String?
    let isNeedLogin: Int?
    let linkUrl: String

    init(id: String,
         title: String,
         keyWordInfo: String?,
         picUrl: String?,
         createdDate: String?,
         isNeedLogin: Int?,
         linkUrl: String) {
        self.id = id
        self.title = title
        self.keyWordInfo = keyWordInfo
        self.picUrl = picUrl
        self.createdDate = createdDate
        self.isNeedLogin = isNeedLogin
        self.linkUrl = linkUrl
    }
}

extension NewsViewModel: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> NewsViewModel? {
        let stringMap = mapToString(dictionary)
        if let id = stringMap("Id"), linkUrl = stringMap("LinkUrl"), title = stringMap("Title") {
            return NewsViewModel(id: id,
                                 title: title,
                                 keyWordInfo: stringMap("KeyWordInfo"),
                                 picUrl: stringMap("PicUrl"),
                                 createdDate: stringMap("CreateDate"),
                                 isNeedLogin: mapToInt(dictionary)("IsNeedLogin"),
                                 linkUrl: linkUrl)
        }
        return nil
    }

}

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
    let isNeedLogin: Bool?
    let linkUrl: String

    init(id: String,
         title: String,
         keyWordInfo: String?,
         picUrl: String?,
         createdDate: String?,
         isNeedLogin: Bool?,
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
                                 isNeedLogin: mapToBool(dictionary)("IsNeedLogin"),
                                 linkUrl: linkUrl)
        }
        return nil
    }

}

final class ExpertViewModel {
    let id: String
    let zName: String?
    let jobName: String?
    let keyWordInfo: String?
    let picUrl: String?
    let createdDate: String?
    let isNeedLogin: Bool?
    
    init(id: String,
         zName: String?,
         jobName: String?,
         keyWordInfo: String?,
         picUrl: String?,
         createdDate: String?,
         isNeedLogin: Bool?) {
        self.id = id
        self.zName = zName
        self.jobName = jobName
        self.keyWordInfo = keyWordInfo
        self.picUrl = picUrl
        self.createdDate = createdDate
        self.isNeedLogin = isNeedLogin
    }
    
}

extension ExpertViewModel: ViewModel {
    
    static func mapToModel(dictionary: [String: AnyObject]) -> ExpertViewModel? {
        let stringMap = mapToString(dictionary)
        if let id = stringMap("Id") {
            return ExpertViewModel(id: id,
                                   zName: stringMap("ZName"),
                                   jobName: stringMap("JobName"),
                                   keyWordInfo: stringMap("KeyWordInfo"),
                                   picUrl: stringMap("PicUrl"),
                                   createdDate: stringMap("CreateDate"),
                                   isNeedLogin: mapToBool(dictionary)("IsNeedLogin"))
        }
        return nil
    }
    
}

final class MeetingViewModel {
//    "Id":"343",
//    "Title":"儿科世界之窗专家答疑集锦（一）：肺炎、中耳炎专题",
//    "KeyWordInfo":"第13届儿科世界之窗已于2016年8月6日顺利闭幕以下为我们收纳整理的本次会议问答集锦本周推荐儿童肺炎和中耳炎~",
//    "PicUrl":"http://app.medhorizon.com.cn/attached/image/20160902/20160902110950_1751.png",
//    "CreateDate":"2016/9/7 11:57:19",
//    "IsNeedLogin":"0",
//    "videoId":"",
//    "LinkUrl":"http://app.medhorizon.com.cn/NewsDetail/News_tophy_Detail.aspx?id=343",
//    "FileNum":"0",
//    "OutLink":""

    let id: String
    let title: String
    let keyWordInfo: String?
    let picUrl: String?
    let createdDate: String?
    let isNeedLogin: Bool?
    let videoId: String?
    let linkUrl: String
    let fileNum: Int?
    let outLink: String?
    
    init(id: String,
         title: String,
         keyWordInfo: String?,
         picUrl: String?,
         createdDate: String?,
         isNeedLogin: Bool?,
         videoId: String?,
         linkUrl: String,
         fileNum: Int?,
         outLink: String?) {
        self.id = id
        self.title = title
        self.keyWordInfo = keyWordInfo
        self.picUrl = picUrl
        self.createdDate = createdDate
        self.isNeedLogin = isNeedLogin
        self.videoId = videoId
        self.linkUrl = linkUrl
        self.fileNum = fileNum
        self.outLink = outLink
    }
}

extension MeetingViewModel: ViewModel {
    
    static func mapToModel(dictionary: [String: AnyObject]) -> MeetingViewModel? {
        let stringMap = mapToString(dictionary)
        if let id = stringMap("Id"), linkUrl = stringMap("LinkUrl"), title = stringMap("Title") {
            return MeetingViewModel(id: id,
                                    title: title,
                                    keyWordInfo: stringMap("KeyWordInfo"),
                                    picUrl: stringMap("PicUrl"),
                                    createdDate: stringMap("CreateDate"),
                                    isNeedLogin: mapToBool(dictionary)("IsNeedLogin"),
                                    videoId: stringMap("videoId"),
                                    linkUrl: linkUrl,
                                    fileNum: mapToInt(dictionary)("FileNum"),
                                    outLink: stringMap("OutLink"))
        }
        return nil
    }
    
}

//"KID":"9",
//"Title":"儿童此类读物",
//"KeyWordInfo":"李元芳",
//"PicUrl":"http://app.medhorizon.com.cn/attached/image/20160504/20160504161813_0740.jpg",
//"NeedScore":"40",
//"CreateDate":"2016/5/5 18:15:15",
//"LinkUrl":"http://app.medhorizon.com.cn/NewsDetail/News_tophykj_Detail.aspx?id=9",
//"SourceUrl":"http://app.medhorizon.com.cn//upload/8.pdf",
//"IsNeedLogin":"0"

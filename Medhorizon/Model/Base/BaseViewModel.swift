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

final class BrannerViewModel {
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

extension BrannerViewModel: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> BrannerViewModel? {
        let stringMap = mapToString(dictionary)
        if let id = stringMap("BrannerId"), linkUrl = stringMap("BrannerLinkUrl") {
            return BrannerViewModel(id: id, title: stringMap("BrannerTitle"), linkUrl: linkUrl, picUrl: stringMap("BrannerPicUrl"))
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

final class ExpertListViewModel {
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

extension ExpertListViewModel: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> ExpertListViewModel? {
        let stringMap = mapToString(dictionary)
        if let id = stringMap("Id") {
            return ExpertListViewModel(id: id,
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

final class ExpertDetailViewModel {
    let expertId: String
    let zName: String?
    let jobName: String?
    let keyWordInfo: String?
    let picUrl: String?

    init(id: String,
         zName: String?,
         jobName: String?,
         keyWordInfo: String?,
         picUrl: String?) {
        self.expertId = id
        self.zName = zName
        self.jobName = jobName
        self.keyWordInfo = keyWordInfo
        self.picUrl = picUrl
    }

}

extension ExpertDetailViewModel: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> ExpertDetailViewModel? {
        let stringMap = mapToString(dictionary)
        if let id = stringMap("ExpertId") {
            return ExpertDetailViewModel(id: id,
                                         zName: stringMap("ZName"),
                                         jobName: stringMap("JobName"),
                                         keyWordInfo: stringMap("KeyWordInfo"),
                                         picUrl: stringMap("PicUrl"))
        }
        return nil
    }
    
}


final class CoursewareInfoViewModel {
    let id: String
    let title: String
    let author: String?
    let picUrl: String?
    let readNum: Int?
    let createdDate: String?
    let linkUrl: String
    let sourceUrl: String
    let isNeedLogin: Bool?
    let needScore: Int?
    let keyWordInfo: String?

    init(id: String,
         title: String,
         author: String?,
         picUrl: String?,
         readNum: Int?,
         createdDate: String?,
         linkUrl: String,
         sourceUrl: String,
         isNeedLogin: Bool?,
         needScore: Int?,
         keyWordInfo: String?) {
        self.id = id
        self.title = title
        self.author = author
        self.picUrl = picUrl
        self.readNum = readNum
        self.createdDate = createdDate
        self.linkUrl = linkUrl
        self.sourceUrl = sourceUrl
        self.isNeedLogin = isNeedLogin
        self.needScore = needScore
        self.keyWordInfo = keyWordInfo
    }
}

extension CoursewareInfoViewModel: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> CoursewareInfoViewModel? {
        let stringMap = mapToString(dictionary)
        let intMap = mapToInt(dictionary)
        if let id = stringMap("Id"),
        title = stringMap("Title"),
        linkUrl = stringMap("LinkUrl"),
        sourceUrl = stringMap("SoureUrl") {
            return CoursewareInfoViewModel(id: id,
                                           title: title,
                                           author: stringMap("Author"),
                                           picUrl: stringMap("PicUrl"),
                                           readNum: intMap("ReadNum"),
                                           createdDate: stringMap("CreateDate"),
                                           linkUrl: linkUrl,
                                           sourceUrl: sourceUrl,
                                           isNeedLogin: mapToBool(dictionary)("IsNeedLogin"),
                                           needScore: intMap("NeedScore"),
                                           keyWordInfo: stringMap("KeyWordInfo"))
        }
        return nil
    }

    static func mapToMeetingModel(dictionary: [String: AnyObject]) -> CoursewareInfoViewModel? {
        let stringMap = mapToString(dictionary)
        let intMap = mapToInt(dictionary)
        if let id = stringMap("KID"),
            title = stringMap("Title"),
            linkUrl = stringMap("LinkUrl"),
            sourceUrl = stringMap("SourceUrl") {
            return CoursewareInfoViewModel(id: id,
                                           title: title,
                                           author: nil,
                                           picUrl: stringMap("PicUrl"),
                                           readNum: intMap("ReadNum"),
                                           createdDate: stringMap("CreateDate"),
                                           linkUrl: linkUrl,
                                           sourceUrl: sourceUrl,
                                           isNeedLogin: mapToBool(dictionary)("IsNeedLogin"),
                                           needScore: intMap("NeedScore"),
                                           keyWordInfo: stringMap("KeyWordInfo"))
        }
        return nil
    }

    static func mapToDocumentModel(dictionary: [String: AnyObject]) -> CoursewareInfoViewModel? {
        let stringMap = mapToString(dictionary)
        let intMap = mapToInt(dictionary)
        if let id = stringMap("ID"),
            title = stringMap("Title"),
            linkUrl = stringMap("LinkUrl"),
            sourceUrl = stringMap("SourceUrl") {
            return CoursewareInfoViewModel(id: id,
                                           title: title,
                                           author: nil,
                                           picUrl: stringMap("PicUrl"),
                                           readNum: intMap("ReadNum"),
                                           createdDate: stringMap("CreateDate"),
                                           linkUrl: linkUrl,
                                           sourceUrl: sourceUrl,
                                           isNeedLogin: mapToBool(dictionary)("IsNeedLogin"),
                                           needScore: intMap("NeedScore"),
                                           keyWordInfo: stringMap("KeyWordInfo"))
        }
        return nil
    }

}

final class VideoDetailInfoViewModel {
    let videoId: String
    let unReadNum: Int?
    let needScore: Int?
    let title: String
    let picList: [String]

    init(videoId: String, title: String, unReadNum: Int?, needScore: Int?, picList: [String]) {
        self.videoId = videoId
        self.title = title
        self.unReadNum = unReadNum
        self.needScore = needScore
        self.picList = picList
    }
}

extension VideoDetailInfoViewModel: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> VideoDetailInfoViewModel? {
        let stringMap = mapToString(dictionary)
        let intMap = mapToInt(dictionary)

        if let videoId = stringMap("VideoId"), title = stringMap("Title") {
            var picList: [String] = []
            if let picJSONList = dictionary["PicList"] as? [[String: AnyObject]] {
                picList = picJSONList.flatMap { $0["PicUrl"] as? String }
            }
            return VideoDetailInfoViewModel(videoId: videoId,
                                            title: title,
                                            unReadNum: intMap("UnReadNum"),
                                            needScore: intMap("NeedScore"),
                                            picList: picList)
        }
        return nil
    }
    
}


final class MeetingViewModel {
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

final class CommentBaseViewModel {
    let pId: String
    let commentName: String?
    let commentPic: String?
    let commentDate: String?
    let commentContent: String?
    let dNum: Int?
    let cNum: Int?

    init(pid: String,
         commentName: String?,
         commentPic: String?,
         commentDate: String?,
         commentContent: String?,
         dNum: Int?,
         cNum: Int?) {
        self.pId = pid
        self.commentPic = commentPic
        self.commentName = commentName
        self.commentDate = commentDate
        self.commentContent = commentContent
        self.cNum = cNum
        self.dNum = dNum
    }
}

extension CommentBaseViewModel: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> CommentBaseViewModel? {
        let stringMap = mapToString(dictionary)
        let intMap = mapToInt(dictionary)
        if let pId = stringMap("PID") {
            return CommentBaseViewModel(pid: pId,
                                        commentName: stringMap("CommentName"),
                                        commentPic: stringMap("CommentPic"),
                                        commentDate: stringMap("CommentDate"),
                                        commentContent: stringMap("CommentContent"),
                                        dNum: intMap("DNum"),
                                        cNum: intMap("CNum"))
        }
        return nil
    }

}

final class CommentViewModel {

    let mainComment: CommentBaseViewModel
    let childComeentList: [CommentBaseViewModel]

    init(main: CommentBaseViewModel, child: [CommentBaseViewModel]) {
        self.mainComment = main
        self.childComeentList = child
    }

    var commentCount: Int {
        return childComeentList.count + 1
    }

    subscript(index: Int) -> (CommentBaseViewModel?, Bool) {
        guard index < commentCount else {
            return (nil, true)
        }

        if index == 0 {
            return (mainComment, true)
        }
        else {
            return (childComeentList[index - 1], false)
        }
    }
}

extension CommentViewModel: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> CommentViewModel? {
        if let mainComment = CommentBaseViewModel.mapToModel(dictionary) {
            var childList: [CommentBaseViewModel] = []
            if let childJSON = dictionary["ChildList"] as? [[String: AnyObject]] {
                childList = childJSON.flatMap {CommentBaseViewModel.mapToModel($0)}
            }
            return CommentViewModel(main: mainComment, child: childList)
        }
        return nil
    }

}

final class LoginBriefInfo {
    let userId: String
    var picUrl: String?
    var nickName: String?
    var phone: String

    init(userId: String, phone: String, nickName: String?, picUrl: String?) {
        self.userId = userId
        self.picUrl = picUrl
        self.nickName = nickName
        self.phone = phone
    }

}

extension LoginBriefInfo {

    static func mapToModel(dictionary: [String: AnyObject], phone: String) -> LoginBriefInfo? {
        let stringMap = mapToString(dictionary)
        if let userId = stringMap("UserId") {
            return LoginBriefInfo (userId: userId, phone: phone, nickName: stringMap("NickName"), picUrl: stringMap("HeadPic"))
        }
        return nil
    }
    
}

final class UserDetailInfo {
    let headpic: String?
    var nickName: String?
    let phone: String?
    let weixin: String?
    let isTrueName: Bool?

    let cartType: Int?
    let WWID: String?
    let hospital: String?
    let department: String?
    let job: String?
    let signDays: Int?
    let unReadNum: Int?

    init(headpic: String?,
         nickName: String?,
         phone: String?,
         weixin: String?,
         isTrueName: Bool?,
         cartType: Int?,
         WWID: String?,
         hospital: String?,
         department: String?,
         job: String?,
         signDays: Int?,
         unReadNum: Int?) {
        self.headpic = headpic
        self.nickName = nickName
        self.phone = phone
        self.weixin = weixin
        self.isTrueName = isTrueName
        self.cartType = cartType
        self.WWID = WWID
        self.hospital = hospital
        self.department = department
        self.job = job
        self.signDays = signDays
        self.unReadNum = unReadNum
    }

}

extension UserDetailInfo: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> UserDetailInfo? {
        let stringMap = mapToString(dictionary)
        let intMap = mapToInt(dictionary)
        let boolMap = mapToBool(dictionary)
        return UserDetailInfo(headpic: stringMap("HeadPic"),
                              nickName: stringMap("NickName"),
                              phone: stringMap("Phone"),
                              weixin: stringMap("WeiXin"),
                              isTrueName: boolMap("IsTrueName"),
                              cartType: intMap("CardType"),
                              WWID: stringMap("WWID"),
                              hospital: stringMap("Hopital"),
                              department: stringMap("Department"),
                              job: stringMap("Job"),
                              signDays: intMap("SignDays"),
                              unReadNum: intMap("UnReadNum"))
    }

}


final class MyMessageViewModel {
    let infoId: String
    let sendName: String?
    let content: String?
    let createdDate: String?

    init(infoId: String, sendName: String?, content: String?, createdDate: String?) {
        self.createdDate = createdDate
        self.infoId = infoId
        self.content = content
        self.sendName = sendName
    }
}

extension MyMessageViewModel: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> MyMessageViewModel? {
        let stringMap = mapToString(dictionary)
        if let infoId = stringMap("InfoId") {
            return MyMessageViewModel(infoId: infoId,
                                      sendName: stringMap("SendName"),
                                      content: stringMap("Content"),
                                      createdDate: stringMap("CreateDate"))
        }
        return nil
    }

}

final class SysMessageViewModel {
    let id: String
    let title: String?
    let content: String?
    let createdDate: String?

    init(id: String, title: String?, content: String?, createdDate: String?) {
        self.createdDate = createdDate
        self.id = id
        self.content = content
        self.title = title
    }
}

extension SysMessageViewModel: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> SysMessageViewModel? {
        let stringMap = mapToString(dictionary)
        if let id = stringMap("Id") {
            return SysMessageViewModel(id: id,
                                       title: stringMap("Title"),
                                       content: stringMap("Content"),
                                       createdDate: stringMap("CreateDate"))
        }
        return nil
    }
    
}

//"Id":"230",
//"InfoId":"302",
//"Title":"宝宝“抽”二手烟，危害远远超乎你的想象",
//"LinkUrl":"http://app.medhorizon.com.cn/NewsDetail/News_Detail.aspx?id=302",
//"PicUrl":"http://app.medhorizon.com.cn/attached/image/20160803/20160803120001_7249.jpg",
//"FId":"5",
//"ReadNum":"125",
//"FNum":"1",
//"SoureUrl":"http://app.medhorizon.com.cn/",
//"TId":"0",
//"VideoId":""

final class FavViewModel {
    let id: String
    let infoId: String
    let title: String
    let linkUrl: String
    let picUrl: String?
    let fid: Int?
    let readNum: Int?
    let favNum: Int?
    let sourceUrl: String?
    let tid: Int?           //1:视频课件 2:专业课件3:电力病例
    let videoId: String?
    init(id: String,
         infoId: String,
         title: String,
         linkUrl: String,
         picUrl: String?,
         fid: Int?,
         readNum: Int?,
         favNum: Int?,
         sourceUrl: String?,
         tid: Int?,
         videoId: String?) {
        self.id = id
        self.infoId = infoId
        self.title = title
        self.linkUrl = linkUrl
        self.picUrl = picUrl
        self.fid = fid
        self.readNum = readNum
        self.favNum = favNum
        self.sourceUrl = sourceUrl
        self.tid = tid
        self.videoId = videoId
    }

}

extension FavViewModel: ViewModel {
    static func mapToModel(dictionary: [String: AnyObject]) -> FavViewModel? {
        let stringMap = mapToString(dictionary)
        let intMap = mapToInt(dictionary)
        if let id = stringMap("Id"),
        infoId = stringMap("InfoId"),
        title = stringMap("Title"),
        linkUrl = stringMap("LinkUrl") {
            return FavViewModel(id: id,
                                infoId: infoId,
                                title: title,
                                linkUrl: linkUrl,
                                picUrl: stringMap("PicUrl"),
                                fid: intMap("FId"),
                                readNum: intMap("ReadNum"),
                                favNum: intMap("FNum"),
                                sourceUrl: stringMap("SoureUrl"),
                                tid: intMap("TId"),
                                videoId: stringMap("VideoId"))
        }
        return nil
    }
}

final class PointViewModel {
    //得分（1:浏览2:评论3:收藏4:点赞5:转发6:意见反馈7:完成实名认证）。减分（8:下载）
    enum PointType: Int {
        case View = 1
        case Comment = 2
        case Fav = 3
        case Prise = 4
        case Share = 5
        case Feedback = 6
        case TrueName = 7
        case Download = 8
        case Other = 0

        var commentString: String {
            switch self {
            case .View:
                return "浏览"
            case .Comment:
                return "评论"
            case .Fav:
                return "收藏"
            case .Prise:
                return "点赞"
            case .Share:
                return "转发"
            case .Feedback:
                return "意见反馈"
            case .TrueName:
                return "完成实名认证"
            case .Download:
                return "下载"
            case .Other:
                return ""
            }
        }
    }

//    "Id":"19",
//    "Title":"",
//    "ScoreType":"1",
//    "Date":"2016/7/9 12:50:28",
//    "ScoreNum":"+2"

    let id: String
    let title: String?
    let pointType: PointType
    let date: String?
    let scoreNum: String?

    init(id: String, title: String?, pointType: PointType, date: String?, scoreNum: String?) {
        self.id = id
        self.title = title
        self.pointType = pointType
        self.date = date
        self.scoreNum = scoreNum
    }

}

extension PointViewModel: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> PointViewModel? {
        let stringMap = mapToString(dictionary)
        let type = mapToInt(dictionary)("ScoreType") ?? 0

        if let id = stringMap("Id"), ptType = PointType(rawValue: type) {
            return PointViewModel(id: id,
                                  title: stringMap("Title"),
                                  pointType: ptType,
                                  date: stringMap("Date"),
                                  scoreNum: stringMap("ScoreNum"))
        }
        return nil
    }

}

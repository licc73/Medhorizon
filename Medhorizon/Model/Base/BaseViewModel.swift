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
//"ID":"240",
//"Title":"儿童腹型过敏性紫癜研究进展",
//"KeyWordInfo":"过敏性紫癜是儿童时期最常见的一种以小血管炎为主要病变的血管炎性疾病。",
//"PicUrl":"http://app.medhorizon.com.cn/attached/image/20160929/20160929105517_8357.jpg",
//"NeedScore":"0",
//"CreateDate":"2016/9/29 10:55:19",
//"IsNeedLogin":"0",
//"SourceUrl":"http://app.medhorizon.com.cn/upload/儿童腹型过敏性紫癜研究进展.pdf",
//"LinkUrl":"http://app.medhorizon.com.cn/NewsDetail/News_tophykj_Detail.aspx?id=240"

//"KID":"9",
//"Title":"儿童此类读物",
//"KeyWordInfo":"李元芳",
//"PicUrl":"http://app.medhorizon.com.cn/attached/image/20160504/20160504161813_0740.jpg",
//"NeedScore":"40",
//"CreateDate":"2016/5/5 18:15:15",
//"LinkUrl":"http://app.medhorizon.com.cn/NewsDetail/News_tophykj_Detail.aspx?id=9",
//"SourceUrl":"http://app.medhorizon.com.cn//upload/8.pdf",
//"IsNeedLogin":"0"

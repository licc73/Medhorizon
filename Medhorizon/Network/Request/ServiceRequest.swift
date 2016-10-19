//
//  ServiceRequest.swift
//  Medhorizon
//
//  Created by Changchun li on 10/8/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa
import Prelude

let defaultAppKey = "827ccb0eea8a706c4c34a16891f84e7b"

struct DefaultServiceRequests {
    
    static let alamofireManager: Alamofire.Manager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        return  Manager(configuration: configuration)
    }()
    
    static func rac_requesForNewsList(departmentId: Int, pageNum: Int, pageSize: Int) -> SignalProducer<(Int, Int, [String: AnyObject]), ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.NewsList(defaultAppKey, departmentId, pageNum, pageSize))
            <~ justCast)
            .map({ (value) -> (Int, Int, [String: AnyObject]) in
                return (departmentId, pageNum, value)
            })
    }
    
    static func rac_requesForWorldInfoList(departmentId: Int, tid: Int, pageNum: Int, pageSize: Int) -> SignalProducer<(Int, Int, Int, [String: AnyObject]), ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.WorldInfoList(defaultAppKey, departmentId, tid, pageNum, pageSize))
            <~ justCast)
            .map({ (value) -> (Int, Int, Int, [String: AnyObject]) in
                return (departmentId, tid, pageNum, value)
            })
    }

    static func rac_requesForExpertDetailInfo(departmentId: Int, expertId: String, tid: Int, pageNum: Int, pageSize: Int) -> SignalProducer<(Int, String, Int, Int, [String: AnyObject]), ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.ExpertDetailInfo(defaultAppKey, departmentId, expertId, tid, pageNum, pageSize))
            <~ justCast)
            .map({ (value) -> (Int, String, Int, Int, [String: AnyObject]) in
                return (departmentId, expertId, tid, pageNum, value)
            })
    }

    static func rac_requesForVideoCoursewareInfo(videoId: String, userId: String?) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.VideoCoursewareInfo(defaultAppKey, videoId, userId ?? "0"))
            <~ justCast
    }

    
    static func rac_requesForMeetingList(departmentId: Int, pageNum: Int, pageSize: Int) -> SignalProducer<(Int, Int, [String: AnyObject]), ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.MeetingInfoList(defaultAppKey, departmentId, pageNum, pageSize))
            <~ justCast)
            .map({ (value) -> (Int, Int, [String: AnyObject]) in
                return (departmentId, pageNum, value)
            })
    }
    
    static func rac_requesForMeetingDetailInfo(meetingId: String, pageNum: Int, pageSize: Int) -> SignalProducer<(String, Int, [String: AnyObject]), ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.MeetingDetailInfo(defaultAppKey, meetingId, pageNum, pageSize))
            <~ justCast)
            .map({ (value) -> (String, Int, [String: AnyObject]) in
                return (meetingId, pageNum, value)
            })
    }
    
    static func rac_requesForDocumentList(departmentId: Int, pageNum: Int, pageSize: Int) -> SignalProducer<(Int, Int, [String: AnyObject]), ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.DocumentInfoList(defaultAppKey, departmentId, pageNum, pageSize))
            <~ justCast)
            .map({ (value) -> (Int, Int, [String: AnyObject]) in
                return (departmentId, pageNum, value)
            })
    }

    static func rac_requesForCommentList(userId: String?, infoId: String, pageNum: Int, pageSize: Int) -> SignalProducer<(String, Int, [String: AnyObject]), ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.CommentList(defaultAppKey, infoId, userId ?? "0", pageNum, pageSize))
            <~ justCast)
            .map({ (value) -> (String, Int, [String: AnyObject]) in
                return (infoId, pageNum, value)
            })
    }

    static func rac_requesForPubComment(infoId: String, userId: String, commentContent: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.PubComment(defaultAppKey, infoId, userId, commentContent))
            <~ justCast
    }

    static func rac_requesForToComment(pId: String, userId: String, commentContent: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.ToComment(defaultAppKey, pId, userId, commentContent))
            <~ justCast
    }

    static func rac_requesForPriseComment(pId: String, userId: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.PriseComment(defaultAppKey, pId, userId))
            <~ justCast
    }
    
}

extension DefaultServiceRequests { //login

    static func rac_requesForLogin(phone: String, pwd: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.Login(defaultAppKey, phone, pwd))
            <~ justCast
    }

    static func rac_requesForLoginWithWX(userId: String?, token: String, openId: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.LoginWithWeixin(defaultAppKey, userId, token, openId))
            <~ justCast
    }

    static func rac_requesForSendSMSCode(phone: String, type: Int) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.SMSCode(defaultAppKey, phone, type))
            <~ justCast
    }

    static func rac_requesForRegister(phone: String, smsCode: String, pwd: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.Register(defaultAppKey, phone, smsCode, pwd))
            <~ justCast
    }

    static func rac_requesForForgotPwd(phone: String, smsCode: String, pwd: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.ForgotPwd(defaultAppKey, phone, smsCode, pwd))
            <~ justCast
    }
}

extension DefaultServiceRequests {

    static func rac_requesForModifyUserNickName(userId: String, nickName: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.ModifyNickName(defaultAppKey, userId, nickName))
            <~ justCast
    }

    static func rac_requesForModifyPhone(userId: String, phone: String, vCode: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.ModifyPhone(defaultAppKey, userId, phone, vCode))
            <~ justCast
    }

    static func rac_requesForModifyPwd(userId: String, oldPwd: String, newPwd: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.ModifyPwd(defaultAppKey, userId, oldPwd, newPwd))
            <~ justCast
    }

    static func rac_requesForTrueName(userId: String, type: Int, wwid: String?, doctor: (String, String, String)?) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.TrueNameCheck(defaultAppKey, userId, type, wwid, doctor))
            <~ justCast
    }
    
}

extension DefaultServiceRequests {//userInfo

    static func rac_requesForGetUserDetail(userId: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.UserDetail(defaultAppKey, userId))
            <~ justCast
    }

    static func rac_requesForMyMessageList(userId: String, pageNum: Int, pageSize: Int) -> SignalProducer<(Int, [String: AnyObject]), ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.MyMessage(defaultAppKey, userId, pageNum, pageSize))
            <~ justCast)
            .map({ (value) -> (Int, [String: AnyObject]) in
                return (pageNum, value)
            })
    }

    static func rac_requesForSysMessageList(userId: String, pageNum: Int, pageSize: Int) -> SignalProducer<(Int, [String: AnyObject]), ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.SysMessage(defaultAppKey, userId, pageNum, pageSize))
            <~ justCast)
            .map({ (value) -> (Int, [String: AnyObject]) in
                return (pageNum, value)
            })
    }

    static func rac_requesForFavList(userId: String, fid: Int, pageNum: Int, pageSize: Int) -> SignalProducer<(Int, [String: AnyObject]), ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.FavList(defaultAppKey, userId, fid, pageNum, pageSize))
            <~ justCast)
            .map({ (value) -> (Int, [String: AnyObject]) in
                return (pageNum, value)
            })
    }

    static func rac_requestForFavOrCancelFav(userId: String, infoId: String, favType: Int) -> SignalProducer<[String: AnyObject], ServiceError> {
        return alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.FavOp(defaultAppKey, userId, infoId, favType))
            <~ justCast
    }

    static func rac_requesForGetFavStatus(userId: String, infoId: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.GetFavStatus(defaultAppKey, userId, infoId))
            <~ justCast)
    }


    static func rac_requesForPointList(userId: String, pageNum: Int, pageSize: Int) -> SignalProducer<(Int, [String: AnyObject]), ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.PointList(defaultAppKey, userId, pageNum, pageSize))
            <~ justCast)
            .map({ (value) -> (Int, [String: AnyObject]) in
                return (pageNum, value)
            })
    }

    static func rac_requesForCheckDownloadStatus(userId: String, infoId: String, scoreNum: Int) -> SignalProducer<[String: AnyObject], ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.CheckCanBeDownloaded(defaultAppKey, userId, infoId, scoreNum))
            <~ justCast)
    }

}

extension DefaultServiceRequests {
//    appKey, appcode, address, uid, version
    static func rac_requesForUpload(appcode: String, address: String, uid: String, version: String) -> SignalProducer<[String: AnyObject], ServiceError> {
        return (alamofireManager.rac_requestResponseJSON(.GET, DefaultServiceAPI.APPStart(defaultAppKey, appcode, address, uid, version))
            <~ justCast)
    }
}

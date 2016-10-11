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

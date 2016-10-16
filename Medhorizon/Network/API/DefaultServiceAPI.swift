//
//  DefaultServiceAPI.swift
//  Medhorizon
//
//  Created by Changchun li on 10/8/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

enum DefaultServiceAPI: API {
    case Login(String, String, String)
    case SMSCode(String, String, Int)
    case Register(String, String, String, String)
    case ForgotPwd(String, String, String, String)

    case UserDetail(String, String)











    case NewsList(String, Int, Int, Int)
    
    case WorldInfoList(String, Int, Int, Int, Int)
    case ExpertDetailInfo(String, Int, String, Int, Int, Int)
    case VideoCoursewareInfo(String, String, String)
    
    case MeetingInfoList(String, Int, Int, Int)
    case MeetingDetailInfo(String, String, Int, Int)
    
    case DocumentInfoList(String, Int, Int, Int)

    case CommentList(String, String, String, Int, Int)
    case PubComment(String, String, String, String)
    case ToComment(String, String, String, String)
    case PriseComment(String, String, String)
    
    static var serviceConfigurationFetcher: (Void -> ServiceConfiguration)? = nil
    static var defaultServiceConfiguration: ServiceConfiguration = ServiceConfiguration(httpProtocol: .HTTP, serviceType: .Default, serviceRegion: .Default, environment: .Default)
    
    func APIPath() -> String {
        switch self{
        case let .Login(appKey, phone, pwd):
            return "/login?AppSecret=\(appKey)&Phone=\(phone)&Pwd=\(pwd)"
        case let .SMSCode(appKey, phone, type):
            return "/sendCode?AppSecret=\(appKey)&Phone=\(phone)&CodeType=\(type)"
        case let .Register(appKey, phone, smsCode, pwd):
            return "/registerInfo?AppSecret=\(appKey)&Phone=\(phone)&VCode=\(smsCode)&Pwd=\(pwd)"
        case let .ForgotPwd(appKey, phone, smsCode, pwd):
            return "/forgotPwd?AppSecret=\(appKey)&Phone=\(phone)&VCode=\(smsCode)&NewPwd=\(pwd)"


        case let .UserDetail(appKey, userId):
            return "/getUserInfo?AppSecret=\(appKey)&UserId=\(userId)"


        
        // server start with 1, page num & page size 意义定义反了
        case let .NewsList(appKey, departmentId, pageNum, pageSize):
            return "/newsInfoList?AppSecret=\(appKey)&DepartmentID=\(departmentId)&PageSize=\(pageNum)&PageNum=\(pageSize)"
            
        case let .WorldInfoList(appKey, departmentId, tid, pageNum, pageSize):
            return "/worldInfoList?AppSecret=\(appKey)&DepartmentID=\(departmentId)&Tid=\(tid)&PageSize=\(pageNum)&PageNum=\(pageSize)"
        case let .ExpertDetailInfo(appKey, departmentId, expertId, tid, pageNum, pageSize):
            return "/getInfoByExpertId?AppSecret=\(appKey)&Nid=\(departmentId)&Id=\(expertId)&Tid=\(tid)&PageSize=\(pageNum)&PageNum=\(pageSize)"
        case let .VideoCoursewareInfo(appKey, videoId, userId):
            return "/getInfoByVideoId?AppSecret=\(appKey)&Id=\(videoId)&UserId=\(userId)"


        case let .MeetingInfoList(appKey, departmentId, pageNum, pageSize):
            return "/meetingInfoList?AppSecret=\(appKey)&DepartmentID=\(departmentId)&PageSize=\(pageNum)&PageNum=\(pageSize)"
        case let .MeetingDetailInfo(appKey, meetingId, pageNum, pageSize):
            return "/getInfoByMeetId?AppSecret=\(appKey)&MID=\(meetingId)&PageSize=\(pageNum)&PageNum=\(pageSize)"
            
        case let .DocumentInfoList(appKey, departmentId, pageNum, pageSize):
            return "/fileList?AppSecret=\(appKey)&DepartmentID=\(departmentId)&PageSize=\(pageNum)&PageNum=\(pageSize)"

        case let .CommentList(appKey, infoId, userId, pageNum, pageSize):
            return "/getCommentByVideoId?AppSecret=\(appKey)&Id=\(infoId)&UserId=\(userId)&PageSize=\(pageNum)&PageNum=\(pageSize)"
        case let .PubComment(appKey, infoId, userId, commentContent):
            return "/pubComment?AppSecret=\(appKey)&Id=\(infoId)&UserId=\(userId)&CommentContent=\(commentContent)"
        case let .ToComment(appKey, pID, userId, commentContent):
            return "/toComment?AppSecret=\(appKey)&PID=\(pID)&UserId=\(userId)&CommentContent=\(commentContent)"
        case let .PriseComment(appKey, pID, userId):
            return "/toComment?AppSecret=\(appKey)&PID=\(pID)&UserId=\(userId)"
        }
    }
}

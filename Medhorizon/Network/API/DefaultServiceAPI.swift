//
//  DefaultServiceAPI.swift
//  Medhorizon
//
//  Created by Changchun li on 10/8/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

enum DefaultServiceAPI: API {
    case APPStart(String, String, String, String, String)
    /////login
    case Login(String, String, String)
    case LoginWithWeixin(String, String?, String, String)
    case SMSCode(String, String, Int)
    case Register(String, String, String, String)
    case ForgotPwd(String, String, String, String)

    //userinfo
    case UserDetail(String, String)

    case ModifyNickName(String, String, String)
    case ModifyPhone(String, String, String, String)
    case ModifyPwd(String, String, String, String)
    case TrueNameCheck(String, String, Int, (String)?, (String, String, String)?)



    //main page
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


    ////// message
    case MyMessage(String, String, Int, Int)
    case SysMessage(String, String, Int, Int)

    case FavList(String, String, Int, Int, Int)
    case FavOp(String, String, String, Int)
    case GetFavStatus(String, String, String)

    case PointList(String, String, Int, Int)

    /// ///

    case CheckCanBeDownloaded(String, String, String, Int)

    
    static var serviceConfigurationFetcher: (Void -> ServiceConfiguration)? = nil
    static var defaultServiceConfiguration: ServiceConfiguration = ServiceConfiguration(httpProtocol: .HTTP, serviceType: .Default, serviceRegion: .Default, environment: .Default)
    
    func APIPath() -> String {
        switch self{
        case let .APPStart(appKey, appcode, address, uid, version):
            return "/appstart?AppSecret=\(appKey)&Appcode=\(appcode)&Adderss=\(address)&Version=\(version)&uid=\(uid)"
        case let .Login(appKey, phone, pwd):
            return "/login?AppSecret=\(appKey)&Phone=\(phone)&Pwd=\(pwd)"
        case let .LoginWithWeixin(appKey, userId, token, openId):
            if let userId = userId {
                return "/wLogin?AppSecret=\(appKey)&UserId=\(userId)&Token=\(token)&OpenId=\(openId)"
            }
            return "/wLogin?AppSecret=\(appKey)&UserId=0&Token=\(token)&OpenId=\(openId)"
        case let .SMSCode(appKey, phone, type):
            return "/sendCode?AppSecret=\(appKey)&Phone=\(phone)&CodeType=\(type)"
        case let .Register(appKey, phone, smsCode, pwd):
            return "/registerInfo?AppSecret=\(appKey)&Phone=\(phone)&VCode=\(smsCode)&Pwd=\(pwd)"
        case let .ForgotPwd(appKey, phone, smsCode, pwd):
            return "/forgotPwd?AppSecret=\(appKey)&Phone=\(phone)&VCode=\(smsCode)&NewPwd=\(pwd)"


        case let .UserDetail(appKey, userId):
            return "/getUserInfo?AppSecret=\(appKey)&UserId=\(userId)"
        case let .ModifyNickName(appKey, userId, nickName):
            return "/modifyNickName?AppSecret=\(appKey)&UserId=\(userId)&NewName=\(nickName)"
        case let .ModifyPhone(appKey, userId, newPhone, vCode):
            return "/modifyPhone?AppSecret=\(appKey)&UserId=\(userId)&NewPhone=\(newPhone)&VCode=\(vCode)"
        case let .ModifyPwd(appKey, userId, oldPwd, newPwd):
            return "/modifyPwd?AppSecret=\(appKey)&UserId=\(userId)&OldPwd=\(oldPwd)&NewPwd=\(newPwd)"

        case let .TrueNameCheck(appKey, userId, cartType, wwid, doctor):
            if let wwid = wwid where cartType == 1 {
                return "/modifyUserInfo?AppSecret=\(appKey)&UserId=\(userId)&CardType=1&WWID=\(wwid)&Hopital=&Department=&Job="
            }
            else if let doctor = doctor where cartType == 2 {
                return "/modifyUserInfo?AppSecret=\(appKey)&UserId=\(userId)&CardType=2&WWID=&Hopital=\(doctor.0)&Department=\(doctor.1)&Job=\(doctor.2)"
            }
            return ""


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



        case let .MyMessage(appKey, userId, pageNum, pageSize):
            return "/getPersonInfoList?AppSecret=\(appKey)&UserId=\(userId)&PageSize=\(pageNum)&PageNum=\(pageSize)"
        case let .SysMessage(appKey, userId, pageNum, pageSize):
            return "/getSysInfoList?AppSecret=\(appKey)&UserId=\(userId)&PageSize=\(pageNum)&PageNum=\(pageSize)"

        case let .FavList(appKey, userId, fid, pageNum, pageSize):
            return "/favoritesList?AppSecret=\(appKey)&UserId=\(userId)&FId=\(fid)&PageSize=\(pageNum)&PageNum=\(pageSize)"
        case let .FavOp(appKey, userId, infoId, op):
            return "/opFavorites?AppSecret=\(appKey)&UserId=\(userId)&InfoId=\(infoId)&Otype=\(op)"
        case let .GetFavStatus(appKey, userId, infoId):
            return "/validateFavorites?AppSecret=\(appKey)&UserId=\(userId)&InfoId=\(infoId)"


        case let .PointList(appKey, userId, pageNum, pageSize):
            return "/scoreList?AppSecret=\(appKey)&UserId=\(userId)&PageSize=\(pageNum)&PageNum=\(pageSize)"

        case let .CheckCanBeDownloaded(appKey, userId, infoId, score):
            return "/firstDown?AppSecret=\(appKey)&UserId=\(userId)&InfoId=\(infoId)&ScoreNum=\(score)"

        }
    }
}

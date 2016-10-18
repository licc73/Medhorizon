//
//  Storyboard.swift
//  Medhorizon
//
//  Created by lich on 10/8/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

struct StoryboardSegue {
    enum Main: String {
        case Main = "Main"
        case ShowNewsDetail = "ShowNewsDetail"
        case ShowCommentList = "ShowCommentList"

        case ShowWorldDetail = "ShowWorldDetail"
        case ShowVideoDetail = "ShowVideoDetail"
        case ShowWorldDetailDetail = "ShowWorldDetailDetail"

        case ShowMeetingDetail = "ShowMeetingDetail"
        case ShowMeetingBranner = "ShowMeetingBranner"
        case ShowMeetingDetailWithWeb = "ShowMeetingDetailWithWeb"
        
        case ShowDocumentInfo = "ShowDocumentInfo"
        case ShowMeetingDoc = "ShowMeetingDoc"

        case ShowNormalLink = "ShowNormalLink"

        case ShowSignupView = "ShowSignupView"
        case ShowForgotPwd = "ShowForgotPwd"

        case ShowUserInfo = "ShowUserInfo"
        case ShowFeedback = "ShowFeedback"
        case ShowMessageView = "ShowMessageView"
        case ShowUserDetailInfo = "ShowUserDetailInfo"
        case ShowFavView = "ShowFavView"
        case ShowPointView = "ShowPointView"
        case ShowDownloadView = "ShowDownloadView"
        case ShowSetupView = "ShowSetupView"

        case ShowChangeNickName = "ShowChangeNickName"
        case ShowChangePhoneView = "ShowChangePhoneView"
        case ShowChangePwdView = "ShowChangePwdView"
        case ShowTrueNameVerifyView = "ShowTrueNameVerifyView"
    }
}
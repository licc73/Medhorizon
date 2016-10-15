//
//  CommentListViewModel.swift
//  Medhorizon
//
//  Created by lichangchun on 10/14/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa

class CommentListViewModel {
    var commentList: [CommentViewModel] = []

    let infoId: String

    var curPage = serverFirstPageNum

    init(infoId: String) {
        self.infoId = infoId
    }

    var isHaveMoreData = false

    var commentCount: Int {
        var iCount = 0
        for comment in commentList {
            iCount += comment.commentCount
        }
        return iCount
    }

    subscript(index: Int) -> (CommentBaseViewModel?, Bool) {
        guard index < commentCount else {
            return (nil, true)
        }

        var iCount = 0
        for comment in commentList {
            let curIndex = index - iCount
            if curIndex >= 0 && curIndex < comment.commentCount {
                return comment[curIndex]
            }
            iCount += comment.commentCount
        }
        return (nil, true)
    }
}

extension CommentListViewModel {
    func performSendRequest(pageNum: Int) -> SignalProducer<ReturnMsg?, ServiceError> {
        return DefaultServiceRequests.rac_requesForCommentList(LoginManager.shareInstance.userId, infoId: self.infoId, pageNum: pageNum, pageSize: pageSize)
            .flatMap(.Latest, transform: { [unowned self] (infoId, page, serviceData) -> SignalProducer<ReturnMsg?, ServiceError> in
                if infoId == self.infoId {
                    let returnMsg = ReturnMsg.mapToModel(serviceData)

                    if let msg = returnMsg where msg.isSuccess {
                        self.curPage = page

                        if let commentList = serviceData["CommentList"] as? [[String: AnyObject]] {
                            let commentListViewModel = commentList.flatMap {CommentViewModel.mapToModel($0)}
                            if serverFirstPageNum == page {
                                self.commentList = commentListViewModel
                            }
                            else {
                                self.commentList.appendContentsOf(commentListViewModel)
                            }

                            if commentList.count == pageSize {
                                self.isHaveMoreData = true
                            }
                            else {
                                self.isHaveMoreData = false
                            }
                        }
                        return SignalProducer(value: msg)
                    }
                    return SignalProducer(value: nil)
                }
                else {
                    return SignalProducer(error: .UnknowError)
                }
                })
    }

    func performRefreshServerFetch() -> SignalProducer<ReturnMsg?, ServiceError> {
        return self.performSendRequest(serverFirstPageNum)
    }

    func performLoadMoreServerFetch() -> SignalProducer<ReturnMsg?, ServiceError> {
        return self.performSendRequest(self.curPage + 1)
    }
}

func performAddComment(userId: String, infoId: String, comment: String) -> SignalProducer<ReturnMsg?, ServiceError> {
    return DefaultServiceRequests.rac_requesForPubComment(infoId, userId: userId, commentContent: comment)
    .flatMap(.Latest, transform: { (object) -> SignalProducer<ReturnMsg?, ServiceError> in
        let returnMsg = ReturnMsg.mapToModel(object)
        return SignalProducer(value: returnMsg)
    })
}

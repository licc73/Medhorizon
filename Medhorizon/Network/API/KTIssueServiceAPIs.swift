//
//  KTIssueServiceAPI.swift
//  Knuth
//
//  Created by ChenYong on 11/17/15.
//  Copyright © 2015 Autodesk. All rights reserved.
//

import Foundation

public enum KTIssueServiceAPI: KTAPI {
    case Health
    case Containers
    case OSSObjects(NSUUID)
    case OneIssues(NSUUID) // PATCH api/v1/issues/00000000-0000-0000-0000-000000000001
    case ContainerIssues(NSUUID)// POST api/v1/containers/00000000-0000-0000-0000-000000000001/issues
    case ContainerMarkups(NSUUID)// GET api/v1/containers/00000000-0000-0000-0000-000000000001/markups
    case ContainerMarkupIssueCount(NSUUID)// GET api/v1/containers/00000000-0000-0000-0000-000000000001/documents?filter[issues.target_urn]=
    case ContainerOneIssue(NSUUID, NSUUID)// PATCH api/v1/containers/00000000-0000-0000-0000-000000000001/issues/00000000-0000-0000-0000-000000000001
    case ContainerOneMarkup(NSUUID, NSUUID)// PATCH api/v1/containers/00000000-0000-0000-0000-000000000004/markups/00000000-0000-0000-0000-000000000003
    case ContainerMarkupAttachments(NSUUID, NSUUID) // /v1/containers/00000000-0000-0000-0000-000000000001/markups/00000000-0000-0000-0000-000000000003/attachments
    case ContainerIssueComments(NSUUID) // Issue ID is embeded into the body for POST request
    case ContainerIssueAttachments(NSUUID) // Issue ID is embeded into the body for POST request
    
    case ContainerIssueChangeSets(NSUUID, NSUUID) // Get api/v1/containers/00000000-0000-0000-0000-000000000001/issues/00000000-0000-0000-0000-000000000003/changesets
    
    public static var serviceConfigurationFetcher: (Void -> KTServiceConfiguration)? = nil
    public static var defaultServiceConfiguration: KTServiceConfiguration = KTServiceConfiguration(httpProtocol: .HTTPS, serviceType: .Issue, serviceRegion: .US, environment: .STAGING)
    
    public func APIPath() -> String {
        switch self{
        case .Health:
            return "/v1/health"
        case .Containers:
            return "/v1/containers"
        case .OSSObjects(let containerId):
            return "/v1/containers/\(containerId.UUIDString)/oss_objects"
        case .OneIssues(let issueId):
            return "/v1/issues/\(issueId.UUIDString)"
        case .ContainerIssues(let containerId):
            return "/v1/containers/\(containerId.UUIDString)/issues"
        case .ContainerMarkups(let containerId):
            return "/v1/containers/\(containerId.UUIDString)/markups"
        case .ContainerMarkupIssueCount(let containerId):
            return "/v1/containers/\(containerId.UUIDString)/documents"//
        case .ContainerOneIssue(let containerId, let issueId):
            return "/v1/containers/\(containerId.UUIDString)/issues/\(issueId.UUIDString)"
        case .ContainerOneMarkup(let containerId, let markupId):
            return "/v1/containers/\(containerId.UUIDString)/markups/\(markupId.UUIDString)"
        case .ContainerMarkupAttachments(let containerId, let markupId):
            return "/v1/containers/\(containerId.UUIDString)/markups/\(markupId.UUIDString)/attachments"
        case .ContainerIssueComments(let containerId):
            return "/v1/containers/\(containerId.UUIDString)/comments"
        case .ContainerIssueAttachments(let containerId):
            return "/v1/containers/\(containerId.UUIDString)/attachments"
        case .ContainerIssueChangeSets(let containerId, let issueId):
            return "/v1/containers/\(containerId.UUIDString)/issues/\(issueId.UUIDString)/changesets"
        }
    }
    
}

//
//  KTDMServiceAPIs.swift
//  Knuth
//
//  Created by ChenYong on 11/19/15.
//  Copyright © 2015 Autodesk. All rights reserved.
//

import Foundation

public enum KTDMServiceAPI: KTAPI {
    case Health
    case Login(String, String)
    case Token
    case System
    case CurrentUser
    case Projects
    case Project(NSUUID)
    case ProjectDetail(NSUUID)
    case ProjectUser(NSUUID)
    case Folders(NSUUID)
    case Folder(NSUUID, String)
    case ProjectRoles(NSUUID)
    case ProjectCompanies(NSUUID)
    case FileStoreURNs
    case DocumentsCreateOrUpdate(NSUUID, String)
    case DocumentsAggregate(NSUUID, String, String)
    case DocumentCalloutlinks(NSUUID, String, String)
    case ProjectDocuments(NSUUID, String)

    public static var serviceConfigurationFetcher: (Void -> KTServiceConfiguration)? = nil
    public static var defaultServiceConfiguration: KTServiceConfiguration = KTServiceConfiguration(httpProtocol: .HTTPS, serviceType: .DM, serviceRegion: .US, environment: .STAGING)


    public func APIPath() -> String {
        switch self {
        case .Health:
            return "/api/v1/health"
        case .Login(let userName, let password):
            return "/oauth/token?username=\(userName)&password=\(password)&grant_type=password"
        case .Token:
            return "/session/token?force_refresh=true"
        case .System:
            return "/api/v1/system"
        case .CurrentUser:
            return "/api/v1/users/current"
        case .Projects:
            return "/api/v1/projects"
        case .Project(let projectId):
            return "/api/v1/projects/\(projectId.UUIDString)"
        case .ProjectDetail(let projectId):
            return "/api/v1/projects/\(projectId.UUIDString)/detail"
        case .ProjectUser(let projectId):
            return "/api/v1/projects/\(projectId.UUIDString)/users"
        case .Folders(let projectId):
            return "/api/v1/projects/\(projectId.UUIDString)/folders"
        case .Folder(let projectId, let folderURN):
            return "/api/v1/projects/\(projectId.UUIDString)/folders/\(folderURN)"
        case .ProjectRoles(let projectId):
            return "/api/v1/projects/\(projectId.UUIDString)/roles"
        case .ProjectCompanies(let projectId):
            return "/api/v1/projects/\(projectId.UUIDString)/companies"
        case .FileStoreURNs:
            return "/api/v1/filestore_urns"
        case .DocumentsCreateOrUpdate(let projectId, let folderURN):
            return "/api/v1/projects/\(projectId.UUIDString)/folders/\(folderURN)/documents"
        case .DocumentsAggregate(let projectId, let folderURN, let urn):
            return "/api/v1/projects/\(projectId.UUIDString)/folders/\(folderURN)/documents/\(urn)/aggregate"
        case .DocumentCalloutlinks(let projectId, let folderURN, let documentURN):
            return "/api/v1/projects/\(projectId.UUIDString)/folders/\(folderURN)/documents/\(documentURN)/attributes?category=dm_calloutlink"
        case .ProjectDocuments(let projectId, let urns):
            return "/api/v1/projects/\(projectId.UUIDString)/documents?document_urns=\(urns)"
        }

    }
    
}

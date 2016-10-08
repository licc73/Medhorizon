//
//  KTOSSServiceAPIs.swift
//  Knuth
//
//  Created by Jason.zhang on 11/19/15.
//  Copyright © 2015 Autodesk. All rights reserved.
//

import Foundation

public enum KTOSSServiceAPI: KTAPI {
    case Authentication
    case Buckets
    case ObjectDetail(String, String)
    case BucketObject(String, String)
    case Bucket(String)
    case Thumbnail(String)
    case ACMSession
    
    public static var serviceConfigurationFetcher: (Void -> KTServiceConfiguration)? = nil
    public static var defaultServiceConfiguration: KTServiceConfiguration = KTServiceConfiguration(httpProtocol: .HTTPS, serviceType: .OSS, serviceRegion: .US, environment: .STAGING)

    public func APIPath() -> String {
        switch self {
        case .Authentication:
            return "/authentication/v1/authenticate"
        case .Buckets:
            return "/oss/v2/buckets"
        case .ObjectDetail(let bucketKey, let objectKey):
            return "/oss/v2/buckets/\(bucketKey)/objects/\(objectKey)/details"
        case .BucketObject(let bucketKey, let objectKey):
            return "/oss/v2/buckets/\(bucketKey)/objects/\(objectKey)"
        case .Bucket(let bucketKey):
            return "/oss/v2/buckets/\(bucketKey)"
        case .Thumbnail(let urn):
            return "/derivativeservice/v2/thumbnails/\(urn)"
        case .ACMSession:
            return "/oss-ext/v1/acmsessions"
        }
    }

}

//
//  KTHttpHeaders.swift
//  Knuth
//
//  Created by ChenYong on 11/19/15.
//  Copyright © 2015 Autodesk. All rights reserved.
//

import Foundation

public enum KTHttpHeader: String {
    case UserAgent = "User-Agent"
    case ContentType = "Content-Type"
    case ContentLength = "Content-Length"
    case Accept = "Accept"
    case CacheControl = "Cache-Control"
    case Authorization = "Authorization"
    case AcmNamespace = "x-ads-acm-namespace"
    case ObjectName = "x-ads-object-name"
    case AppVersion = "x-app-version"
}


public enum KTContentType: String {
    case FormEncoded = "application/x-www-form-urlencoded"
    case JSON = "application/json"
    case JSONAPI = "application/vnd.api+json"
}

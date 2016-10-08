//
//  KTAPI.swift
//  Knuth
//
//  Created by ChenYong on 11/17/15.
//  Copyright © 2015 Autodesk. All rights reserved.
//

import Foundation
import Alamofire


public enum KTHTTPProtocol: String {
    case HTTP = "http"
    case HTTPS = "https"
}

public enum KTServiceType{
    case Issue
    case DM
    case OSS
    
    static let allValues = [KTServiceType.Issue, KTServiceType.DM, KTServiceType.OSS]
}

public enum KTServiceRegion{
    case US
    case EMEA
}

public enum KTServiceEnvironment{
    case PRODUCTION
    case STAGING
    case QA
    case DEV
}

public struct KTServiceConfiguration{
    public let httpProtocol: KTHTTPProtocol
    public let serviceType: KTServiceType
    public let serviceRegion: KTServiceRegion
    public let environment: KTServiceEnvironment
    
    //
    //THIS IS A WORKAROUND FOR SWIFT BUG: without this init, 
    //calling to this struct inside a framework would cause compile error: KTServiceConfiguration can not be constructed as ... inaccessbile intializers
    //
    public init(httpProtocol: KTHTTPProtocol, serviceType: KTServiceType, serviceRegion: KTServiceRegion,  environment: KTServiceEnvironment){
        self.httpProtocol = httpProtocol
        self.serviceType = serviceType
        self.serviceRegion = serviceRegion
        self.environment = environment
    }
    
    
    func hostName() -> String{
        
        switch(serviceType, serviceRegion, environment){
            
        //
        //Issue Service
        //
        // ------------------ Region: US --------------------
        //
        case (.Issue, .US, .PRODUCTION):
            return "developer.api.autodesk.com/issues"
        case (.Issue, .US, .STAGING):
            return "developer-stg.api.autodesk.com/issues-stg"
        case (.Issue, .US, .QA):
            return "developer-stg.api.autodesk.com/issues-qa"
        case (.Issue, .US, .DEV):
            return "developer-stg.api.autodesk.com/issues-dev"
        //
        // ------------------ Region: EMEA --------------------
        //
        case (.Issue, .EMEA, .PRODUCTION):
            return "developer.api.autodesk.com/issues"
        case (.Issue, .EMEA, .STAGING):
            return "developer-stg.api.autodesk.com/issues-stg"
        case (.Issue, .EMEA, .QA):
            return "developer-stg.api.autodesk.com/issues-qa"
        case (.Issue, .EMEA, .DEV):
            return "developer-stg.api.autodesk.com/issues-dev"
            
            
        //
        //DM Service
        //
        // ------------------ Region: US --------------------
        //
        case (.DM, .US, .PRODUCTION):
            return "bim360docs.autodesk.com"
        case (.DM, .US, .STAGING):
            return "bim360dm-staging.autodesk.com"
        case (.DM, .US, .QA):
            return "bim360dm-qa.autodesk.com"
        case (.DM, .US, .DEV):
            return "bim360dm-dev.autodesk.com"
        //
        // ------------------ Region: EMEA --------------------
        //
        case (.DM, .EMEA, .PRODUCTION):
            return "bim360docs.eu.autodesk.com"
        case (.DM, .EMEA, .STAGING):
            return "bim360dm-staging.eu.autodesk.com"
        case (.DM, .EMEA, .QA):
            return "bim360dm-qa.eu.autodesk.com"
        case (.DM, .EMEA, .DEV):
            return "bim360dm-dev.eu.autodesk.com"
            
            
        //
        //OSS Service
        //
        // ------------------ Region: US --------------------
        //
        case (.OSS, .US, .PRODUCTION):
            return "developer.api.autodesk.com"
        case (.OSS, .US, .STAGING):
            return "developer-stg.api.autodesk.com"
        case (.OSS, .US, .QA):
            return "developer-qa.api.autodesk.com"
        case (.OSS, .US, .DEV):
            return "developer-dev.api.autodesk.com"
        //
        // ------------------ Region: EMEA --------------------
        //
        case (.OSS, .EMEA, .PRODUCTION):
            return "developer.api.autodesk.com"
        case (.OSS, .EMEA, .STAGING):
            return "developer-stg.api.autodesk.com"
        case (.OSS, .EMEA, .QA):
            return "developer-stg.api.autodesk.com"
        case (.OSS, .EMEA, .DEV):
            return "developer-dev.api.autodesk.com"
        }
    }
    
    public func url() -> String{
        return httpProtocol.rawValue + "://" + hostName()
    }
}

public protocol KTAPI: URLStringConvertible{
    func APIPath() -> String
    func url() -> String
    var URLString: String { get }
    static var serviceConfigurationFetcher: (Void -> KTServiceConfiguration)? {get set}
    static var defaultServiceConfiguration: KTServiceConfiguration {get set}
}

public extension KTAPI {
     func url() -> String{
        let sf: KTServiceConfiguration
        if let f = Self.serviceConfigurationFetcher{
            sf = f()
        }else{
            sf = Self.defaultServiceConfiguration
        }
        return sf.url() + APIPath()
    }
    
    var URLString: String {
        return url()
    }
}



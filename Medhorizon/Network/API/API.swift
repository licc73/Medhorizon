//
//  API.swift
//

import Foundation
import Alamofire


enum HTTPProtocol: String {
    case HTTP = "http"
    case HTTPS = "https"
}

enum ServiceType{
    case Default    
    static let allValues = [ServiceType.Default]
}

enum ServiceRegion{
    case Default
}

enum ServiceEnvironment{
    case Default
}

public struct ServiceConfiguration{
    let httpProtocol: HTTPProtocol
    let serviceType: ServiceType
    let serviceRegion: ServiceRegion
    let environment: ServiceEnvironment
    
    init(httpProtocol: HTTPProtocol, serviceType: ServiceType, serviceRegion: ServiceRegion,  environment: ServiceEnvironment){
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
        case (.Default, .Default, .Default):
            return "http://app.medhorizon.com.cn"
            
        }
    }
    
    func url() -> String{
        return httpProtocol.rawValue + "://" + hostName()
    }
}

public protocol API: URLStringConvertible{
    func APIPath() -> String
    func url() -> String
    var URLString: String { get }
    static var serviceConfigurationFetcher: (Void -> ServiceConfiguration)? {get set}
    static var defaultServiceConfiguration: ServiceConfiguration {get set}
}

public extension API {
    func url() -> String{
        let sf: ServiceConfiguration
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

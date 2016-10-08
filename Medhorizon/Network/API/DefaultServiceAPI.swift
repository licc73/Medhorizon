//
//  DefaultServiceAPI.swift
//  Medhorizon
//
//  Created by Changchun li on 10/8/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

enum DefaultServiceAPI: API {
    case Login
    
    static var serviceConfigurationFetcher: (Void -> ServiceConfiguration)? = nil
    static var defaultServiceConfiguration: ServiceConfiguration = ServiceConfiguration(httpProtocol: .HTTP, serviceType: .Default, serviceRegion: .Default, environment: .Default)
    
    func APIPath() -> String {
        switch self{
        case .Login:
            return "/v1/health"
        }
    }
}

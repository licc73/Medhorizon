//
//  Error.swift
//  ServiceError
//

import Foundation
import Result

public struct RawResponse {
    public let request: NSURLRequest?
    public let response: NSHTTPURLResponse?
    public let data: NSData?
    
    public init(request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?){
        self.request = request
        self.response = response
        self.data = data
    }
}

extension RawResponse: CustomStringConvertible{
    public var requestDescription: String{
        if let request = self.request{
            var rs = "Request => \(self.request)\n"
            if let headers = request.allHTTPHeaderFields{
                rs += "Request Headers => \(headers)\n"
            }
            
            if let body = request.HTTPBody{
                rs += "Request Body => \(String(data: body, encoding: NSUTF8StringEncoding))\n"
            }
            
            return rs
            
        }else{
            return "Empty Request\n"
        }
    }
    
    public var description: String{
        return "\n============================= Dump Of RawResponse =============================\n" +
               self.requestDescription +
               "Response Headers => \(self.response)\n" +
               "Response => \(self.data != nil ? String(data: self.data!, encoding: NSUTF8StringEncoding) : "Empty")\n" +
               "-------------------------------- End of Dump ----------------------------------"
    }
}

public enum ServerResponseType{
    case RDict([String: AnyObject])
    case RArray([[String: AnyObject]])
    case RAnyObject(AnyObject)
    
    public static func from(o: AnyObject) -> ServerResponseType{
        if let dict = o as? [String: AnyObject]{
            return .RDict(dict)
        }else if let arr = o as? [[String: AnyObject]]{
            return .RArray(arr)
        }else{
            return .RAnyObject(o)
        }
    }
}

public enum ServiceError: ErrorType{
    case OptionalMapError(ServerResponseType) //Map Value from NEXT error
    case AlamofireError(RawResponse, NSError)
    case ConnectionError(NSError) //DNS resolving problem, server not reachable, timeout
    case MultipartFormDataEncodingError //Multipart Form Data Encoding Error
    case NoAccessToken
    case CoreDataError
    case UnknowError
    case NoError
}



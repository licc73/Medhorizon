//
//  AlamofireRACRequestJSON.swift
//

import Foundation
import Alamofire
import ReactiveCocoa
import Runes
import Result

let responseProcessQueue = dispatch_queue_create("knuth_alamofire_response_processing_queue", nil)


func processConnectionError(rawResponse: RawResponse, _ error: NSError) -> ServiceError {
    switch error.code {
    case -1009, -1003, -1001, -1005:
        return .ConnectionError(error)
    default:
        return .AlamofireError(rawResponse, error)

    }
}

private func totalExpectedBytes(expected: Int64, prepared: Int64?) -> Int64 {
    if let prepared = prepared where expected <= 0 && prepared > 0 {
        return prepared
    } else {
        return expected
    }
}


extension Alamofire.Response {

    func toRawResponse() -> RawResponse {
        return RawResponse(request: self.request, response: self.response, data: self.data)
    }

}

extension Alamofire.Request {

    public func responseJSON(
        queue: dispatch_queue_t? = responseProcessQueue,
        options: NSJSONReadingOptions = .AllowFragments,
        completionHandler: (Response<AnyObject, NSError>) -> Void)
        -> Self {
        return response(queue: queue, responseSerializer: Request.JSONResponseSerializer(options: options), completionHandler: completionHandler)
    }

    public func rac_responseJSONWithResponse(
        queue: dispatch_queue_t? = responseProcessQueue,
        options: NSJSONReadingOptions = .AllowFragments)
        -> SignalProducer<(value: AnyObject, response: RawResponse), ServiceError> {
        return SignalProducer {sink, _ in
            self.responseJSON(  queue, options: options, completionHandler: { (response) -> Void in
                // print(String(data: response.data!, encoding: NSUTF8StringEncoding))
                let rawResponse = response.toRawResponse()
                switch response.result {
                case .Success(let JSON):
                    sink.sendNext((JSON, rawResponse))
                    sink.sendCompleted()
                case .Failure(let error):
                    if let data = response.data, s = NSString.init(data: data, encoding: NSUTF8StringEncoding) {
                        let s1 = s.stringByReplacingOccurrencesOfString("\r", withString: "")
                        let s2 = s1.stringByReplacingOccurrencesOfString("\n", withString: "")
                        if let d = s2.dataUsingEncoding(NSUTF8StringEncoding) {
                            do {
                                let parserData = try NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments)
                                sink.sendNext((parserData, rawResponse))
                                sink.sendCompleted()
                                return
                            }
                            catch {

                            }
                        }

                    }
                    sink.sendFailed(processConnectionError(rawResponse, error))
                }
            })
        }
    }


    public func rac_progressResponse(preparedSize: Int64? = nil, file: Void -> NSURL?) -> SignalProducer<RequestProgress, ServiceError> {

        return SignalProducer {sink, _ in
            self.validate().progress { sink.sendNext(RequestProgress.InProgress(bytesRead: $0, totalBytesRead: $1, totalBytesExpectedToRead: totalExpectedBytes($2, prepared: preparedSize)))}
                .response { (request, response, data, error) -> Void in
                    if let error = error {
                        sink.sendFailed(processConnectionError(RawResponse(request: request, response: response, data: data), error))
                    } else {
                        if let file = file() {
                           sink.sendNext(RequestProgress.FileFinished(file))
                        } else {
                            sink.sendNext(RequestProgress.Finished)
                        }

                        sink.sendCompleted()
                    }
                }
        }

    }
    
}


extension Alamofire.Manager {

    public func requestNoContentTypeOverride(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil)
        -> Request {
        //
        // 1. Generate mutable request
        //
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: URLString.URLString)!)
        mutableURLRequest.HTTPMethod = method.rawValue

        //
        // 2. set headers
        //
        if let headers = headers {
            for (headerField, headerValue) in headers {
                mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }

        //
        // 3. Encode
        //
        let encodedURLRequest = encoding.encode(mutableURLRequest, parameters: parameters).0

        if let jsonapi = headers?[HttpHeader.ContentType.rawValue] >>- {ContentType(rawValue: $0)} where jsonapi == ContentType.JSONAPI {
            encodedURLRequest.setValue( ContentType.JSONAPI.rawValue, forHTTPHeaderField: HttpHeader.ContentType.rawValue)
        }

        return request(encodedURLRequest)
    }

    public func rac_requestResponseJSONWithResponse(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        queue: dispatch_queue_t? = responseProcessQueue)
        -> SignalProducer< (value: AnyObject, response: RawResponse), ServiceError> {
        //
        // As by default, Alamofire will start the request once the request is created,
        // request creation has to be put in a closure that will be executed by on start
        //
        return SignalProducer<SignalProducer< (value: AnyObject, response: RawResponse), ServiceError>, ServiceError> {(observer, _) in
            let sp = self.requestNoContentTypeOverride(method, URLString, parameters: parameters, encoding: encoding, headers: headers)
                .validate()
                .rac_responseJSONWithResponse()

            observer.sendNext(sp)
            observer.sendCompleted()
            }.flatten(.Latest)
    }

    public func rac_requestResponseJSONWithResponseOnMain(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil)
        -> SignalProducer< (value: AnyObject, response: RawResponse), ServiceError> {
        return rac_requestResponseJSONWithResponse(method, URLString, parameters: parameters, encoding: encoding, headers: headers, queue: nil)
    }

    public func rac_requestResponseJSON(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        queue: dispatch_queue_t? = responseProcessQueue)
        -> SignalProducer<AnyObject, ServiceError> {
        return rac_requestResponseJSONWithResponse(method, URLString, parameters: parameters, encoding: encoding, headers: headers, queue: queue)
                .map {$0.0}
//            .map{ object in
//            print(NSString(data: object.1.data!, encoding: NSUTF8StringEncoding))
//            return object.0}
    }

    public func rac_requestResponseJSONOnMain(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil)
        -> SignalProducer<AnyObject, ServiceError> {
        return rac_requestResponseJSON(method, URLString, parameters: parameters, encoding: encoding, headers: headers, queue: nil)
    }
}

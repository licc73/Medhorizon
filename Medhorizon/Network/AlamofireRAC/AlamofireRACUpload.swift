//
//  AlamofireRACUpload.swift
//

import Foundation
import Alamofire
import ReactiveCocoa

extension Alamofire.Manager {

    public func rac_upload(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        headers: [String: String]? = nil,
        file: NSURL)
        -> SignalProducer<NSURL, ServiceError> {
        return SignalProducer {sink, _ in

            self.upload(method, URLString, headers: headers, file: file)
                .response { (request, response, data, error) -> Void in
                if let error = error {
                    sink.sendFailed(processConnectionError(RawResponse(request: request, response: response, data: data), error))
                } else {
                    sink.sendNext(file)
                    sink.sendCompleted()
                }
            }
        }
    }


    private func rac_encodeMultipartFormDataToRequest(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        headers: [String: String]? = nil,
        multipartFormData: MultipartFormData -> Void)
        -> SignalProducer<Alamofire.Request, ServiceError> {
        return SignalProducer {sink, _ in
            self.upload(method, URLString, headers: headers, multipartFormData: multipartFormData, encodingCompletion: { (result) -> Void in
                switch result {
                case .Success(let upload, _, _):
                    sink.sendNext(upload)
                    sink.sendCompleted()
                case .Failure:
                    sink.sendFailed(.MultipartFormDataEncodingError)
                }
            })

        }
    }

    public func rac_upload(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        headers: [String: String]? = nil,
        multipartFormData: MultipartFormData -> Void)
        -> SignalProducer<AnyObject, ServiceError> {
        return rac_encodeMultipartFormDataToRequest(method, URLString, headers: headers, multipartFormData: multipartFormData).flatMap(.Latest, transform: { (request) -> SignalProducer<AnyObject, ServiceError> in
            request.rac_responseJSONWithResponse(nil).map {$0.0}
        })
    }

    public func rac_uploadWithProgress(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        headers: [String: String]? = nil,
        file: NSURL)
        -> SignalProducer<RequestProgress, ServiceError> {

            return SignalProducer {sink, _ in
                self.upload(method, URLString, headers: headers, file: file)
                    .validate()
                    .progress { sink.sendNext(RequestProgress.InProgress(bytesRead: $0, totalBytesRead: $1, totalBytesExpectedToRead: $2)) }
                    .response { (request, response, data, error) -> Void in
                        if let error = error {
                            sink.sendFailed(processConnectionError(RawResponse(request: request, response: response, data: data), error))
                        } else {
                            sink.sendNext(RequestProgress.FileFinished(file))
                            sink.sendCompleted()
                        }
                }
            }
    }

    public func rac_uploadWithProgress(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        headers: [String: String]? = nil,
        multipartFormData: MultipartFormData -> Void)
        -> SignalProducer<RequestProgress, ServiceError> {
        return rac_encodeMultipartFormDataToRequest(method, URLString, headers: headers, multipartFormData: multipartFormData).flatMap(.Latest, transform: { (request) -> SignalProducer<RequestProgress, ServiceError> in
            return request.rac_progressResponse(nil, file: {nil})
            })
    }

}

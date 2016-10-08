//
//  AlamofireRACDownload.swift
//

import Foundation
import Alamofire
import ReactiveCocoa

public enum RequestProgress {
    case InProgress(bytesRead: Int64, totalBytesRead: Int64, totalBytesExpectedToRead: Int64)
    case FileFinished(NSURL)
    case Finished
}


extension Alamofire.Manager {

    public func rac_download(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        destination: Request.DownloadFileDestination)
        -> SignalProducer<NSURL, ServiceError> {
        return SignalProducer {sink, _ in
            var d: NSURL! = nil
            let f: Request.DownloadFileDestination = {tempURL, response in
                let dest = destination(tempURL, response)
                d = dest
                return dest
            }

            self.download(method, URLString, parameters: parameters, encoding: encoding, headers: headers, destination: f).validate().response { (request, response, data, error) -> Void in
                if let error = error {
                    sink.sendFailed(processConnectionError(RawResponse(request: request, response: response, data: data), error))
                } else {
                    sink.sendNext(d)
                    sink.sendCompleted()
                }
            }
        }
    }


    public func rac_downloadWithProgress(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil,
        fileSize: Int64? = nil,
        destination: Request.DownloadFileDestination)
        -> SignalProducer<RequestProgress, ServiceError> {
            return SignalProducer<SignalProducer<RequestProgress, ServiceError>, ServiceError> {[unowned self] sink, _ in
                var d: NSURL! = nil
                let f: Request.DownloadFileDestination = {tempURL, response in
                    let dest = destination(tempURL, response)
                    d = dest
                    return dest
                }

                let sp = self.download(method, URLString, parameters: parameters, encoding: encoding, headers: headers, destination: f)
                    .rac_progressResponse(fileSize, file: {d})
                sink.sendNext(sp)
                sink.sendCompleted()
            }.flatten(.Latest)
    }

}

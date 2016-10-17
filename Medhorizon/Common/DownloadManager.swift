//
//  DownloadManager.swift
//  Medhorizon
//
//  Created by lich on 10/12/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result
import Alamofire

//<key>FileType</key>
//<integer>2</integer>
//<key>PicUrl</key>
//<string>http://app.medhorizon.com.cn/attached/image/20160802/20160802135906_5625.jpg</string>
//<key>Progress</key>
//<real>1</real>
//<key>SourceUrl</key>
//<string>http://app.medhorizon.com.cn/upload/儿童急性呼吸道多病原体混合感染的研究进展.pdf</string>
//<key>Status</key>
//<integer>3</integer>
//<key>Title</key>
//<string>儿童急性呼吸道多病原体混合感染的研究进展</string>

private let downloadFileTypeKey = "FileType"
private let downloadPicUrlKey = "PicUrl"
private let downloadProgressKey = "Progress"
private let downloadSourceUrlKey = "SourceUrl"
private let downloadStatusKey = "Status"
private let downloadTitleUrlKey = "Title"
private let downloadUserIdKey = "UserId"

struct DownloadItem {
    let sourceUrl: String
    let fileType: DownloadFileType           //1 video  2 doc
    let picUrl: String
    var status: DownloadStatus
    let title: String
    var progress: Double
    var userId: String          //

    var downloadItem: DWDownloader?

}

extension DownloadItem {
    static func mapToSelf(dictionary: [String: AnyObject]) -> DownloadItem? {
        let stringMap = mapToString(dictionary)
        let intMap = mapToInt(dictionary)
        if let sourceUrl = stringMap(downloadSourceUrlKey),
            fileType = intMap(downloadFileTypeKey),
            type = DownloadFileType(rawValue: fileType),
            picUrl = stringMap(downloadPicUrlKey),
            status = intMap(downloadStatusKey), downloadStatus = DownloadStatus(rawValue: status),
            title = stringMap(downloadTitleUrlKey),
            progress = mapToDouble(dictionary)(downloadProgressKey),
            userId = stringMap(downloadUserIdKey){
            return DownloadItem(sourceUrl: sourceUrl, fileType: type, picUrl: picUrl, status: downloadStatus, title: title, progress: progress, userId: userId, downloadItem: nil)
        }
        return nil
    }

    func mapToFlatten() -> [String: AnyObject] {
        return [downloadSourceUrlKey: self.sourceUrl,
                downloadFileTypeKey: self.fileType.rawValue,
                downloadPicUrlKey: self.picUrl,
                downloadStatusKey: self.status.rawValue,
                downloadTitleUrlKey: self.title,
                downloadProgressKey: self.progress,
                downloadUserIdKey: self.userId]
    }
}

enum DownloadFileType: Int {
    case Video = 1
    case Document = 2
}

enum DownloadStatus: Int {
    case Wait = 1
    case Start
    case Downloading
    case Pause
    case Finish
    case Fail
}

extension DownloadItem {

    static func filePathWithSource(sourceUrl: String, type: DownloadFileType) -> String {
        if type == .Video {
            let fileName = sourceUrl.md5 + ".mp4"
            return curUserFolder() + "/document/" + fileName
        }
        else {
            let ext = (sourceUrl as NSString).pathExtension
            let fileName = sourceUrl.md5 + "." + ext
            return curUserFolder() + "/document/" + fileName
        }
    }

    func getResourcePath() -> String {
        if self.fileType == .Video {
            let fileName = sourceUrl.md5 + ".mp4"
            return userFolderWithUserId(self.userId) + "/document/" + fileName
        }
        else {
            let ext = (self.sourceUrl as NSString).pathExtension
            let fileName = sourceUrl.md5 + "." + ext
            return userFolderWithUserId(self.userId) + "/document/" + fileName
        }
    }

    func removeSource() {
        let path = self.getResourcePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            _ = try? NSFileManager.defaultManager().removeItemAtPath(path)
        }
    }

    mutating func startDownload() {
        let fileDesPath = self.getResourcePath()
        if NSFileManager.defaultManager().fileExistsAtPath(fileDesPath) {
            _ = try? NSFileManager.defaultManager().removeItemAtPath(fileDesPath)
        }

        if self.fileType == .Video {
            let videoDownloader = DWDownloader(userId: "608FFD6E33B2DE5E", andVideoId: self.sourceUrl, key: "qRTrQyHPQHEpVu45fVZyqrN8amDBRMY4", destinationPath: fileDesPath)
            videoDownloader.timeoutSeconds = 40

            self.progress = 0
            self.status = .Downloading
            DownloadManager.shareInstance.downloadHotSignal.value = self
            
            videoDownloader.failBlock = { error in
                self.progress = 0
                self.status = .Fail

                DownloadManager.shareInstance.downloadHotSignal.value = self
            };

            videoDownloader.finishBlock = { _ in
                self.progress = 1
                self.status = .Finish

               DownloadManager.shareInstance.downloadHotSignal.value = self
            }

            videoDownloader.progressBlock = { progress, _, _ in
                self.progress = Double(progress)
                self.status = .Downloading

                DownloadManager.shareInstance.downloadHotSignal.value = self
            }

            videoDownloader.start()
            self.downloadItem = videoDownloader
        }
        else {
           Alamofire.Manager.sharedInstance.rac_downloadWithProgress(.GET, self, destination: { (tmpUrl, response) -> NSURL in
                return NSURL(fileURLWithPath: fileDesPath)
            })
                .on(started: {
                    self.progress = 0
                    self.status = .Downloading

                    DownloadManager.shareInstance.downloadHotSignal.value = self
                    },
                    failed: { error in
                        self.progress = 0
                        self.status = .Fail
                        print(error)

                        DownloadManager.shareInstance.downloadHotSignal.value = self
                    },
                    next: { progress in
                        switch progress {
                        case .InProgress(bytesRead: let r, totalBytesRead: let t, totalBytesExpectedToRead: let e):
                            self.status = .Downloading
                            self.progress = Double(t) / Double(e)
                            print("Download progress: bytesRead: \(r) totalBytesRead: \(t) totalBytesExpectedToRead: \(e)")
                            DownloadManager.shareInstance.downloadHotSignal.value = self

                        case .FileFinished(let url):
                            print(url)
                            self.progress = 1
                            self.status = .Finish

                            DownloadManager.shareInstance.downloadHotSignal.value = self                        default:
                            break
                        }
                }).start()

        }

    }
}

extension DownloadItem: URLStringConvertible {
    var URLString: String {
        let allowedCharacters = NSCharacterSet.URLQueryAllowedCharacterSet()
        let apiPath = self.sourceUrl.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
        return apiPath ?? ""
    }
}

let documentFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
let downloadManagerFile = "downloadlist.plist"

func curUserFolder() -> String {
    guard let userId = LoginManager.shareInstance.userId else {
        return userFolderWithUserId("0")
    }
    return userFolderWithUserId(userId)
}

func userFolderWithUserId(userId: String) -> String {
    return documentFolder + "/" + "\(userId)"
}

func downloadManagerFilePath() -> String {
    return curUserFolder() + "/" + downloadManagerFile
}

func downloadedFileFolder() -> String {
    return curUserFolder() + "/document"
}

func createFolder(folder: String) {
    if !NSFileManager.defaultManager().fileExistsAtPath(folder) {
         _ = try? NSFileManager.defaultManager().createDirectoryAtPath(folder, withIntermediateDirectories: true, attributes: nil)
    }
}

class DownloadManager {
    static let shareInstance = DownloadManager()

    var downloadedList: [DownloadItem] = []
    var needBeDownloadedList: [DownloadItem] = []
    var failedList: [DownloadItem] = []

    var isDownloading = false

    let downloadHotSignal: MutableProperty<DownloadItem?> = MutableProperty(nil)

    init() {
        self.reloadData()
        self.downloadHotSignal.producer.startWithNext { (item) in
            if let item = item {
                if item.status == .Fail {
                    self.downloadFailed(item)
                    self.downloadNext()
                    self.isDownloading = false
                }
                else if item.status == .Finish {
                    self.downloadSuc(item)
                    self.downloadNext()
                    self.isDownloading = false
                }
            }
        }

        LoginManager.shareInstance.loginOrLogoutNotification.producer.skip(1).startWithNext {[unowned self] (_) in
            self.reloadData()
        }

    }

    func reloadData() {
        self.downloadedList.removeAll()
        self.needBeDownloadedList.removeAll()
        self.failedList.removeAll()

        guard LoginManager.shareInstance.isLogin else {
            return
        }

        let downloadFile = downloadManagerFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(downloadFile) {
            createFolder(downloadedFileFolder())
            if let downloadListPlist = NSArray(contentsOfFile: downloadFile) as? [[String: AnyObject]] {
                let downloadList = downloadListPlist.flatMap({ (object) -> DownloadItem? in
                    return DownloadItem.mapToSelf(object)
                })

                for item in downloadList {
                    if item.status == .Finish {
                        self.downloadedList.append(item)
                    }
                    else if item.status == .Fail {
                        self.failedList.append(item)
                    }
                    else {
                        self.needBeDownloadedList.append(item)
                    }
                }

            }

        }
        else {
            createFolder(curUserFolder())
            createFolder(downloadedFileFolder())
        }

    }

    func saveInfo() {
        
        if LoginManager.shareInstance.isLogin {
            let result = downloadedList + needBeDownloadedList + failedList
            (result.map{ $0.mapToFlatten() } as NSArray).writeToFile(downloadManagerFilePath(), atomically: true)
        }
    }


    func isSuccessDownloaded(sourceUrl: String) -> Bool {
        for item in self.downloadedList {
            if item.sourceUrl == sourceUrl {
                return true
            }
        }
        return false
    }

    func isInToBeDownload(sourceUrl: String) -> Bool {
        for item in self.needBeDownloadedList {
            if item.sourceUrl == sourceUrl {
                return true
            }
        }
        return false
    }

    func checkAndAddToQueue(item: DownloadItem) {
        self.needBeDownloadedList.append(item)
        let index: Int? = self.failedList.indexOf { (tmp) -> Bool in
            tmp.sourceUrl == item.sourceUrl
        }
        if let index = index {
            self.failedList.removeAtIndex(index)
        }

    }

    func downloadNext() {
        if self.isDownloading {

        }
        else {
            if self.needBeDownloadedList.count > 0 {
                self.isDownloading = true
                self.needBeDownloadedList[0].startDownload()
            }
            else {
                self.isDownloading = false
            }
        }
    }

    func downloadSuc(item: DownloadItem) {
        let index: Int? = self.needBeDownloadedList.indexOf { (tmp) -> Bool in
            tmp.sourceUrl == item.sourceUrl
        }
        if let index = index {
            self.needBeDownloadedList.removeAtIndex(index)
        }
        self.downloadedList.insert(item, atIndex: 0)
        
        self.saveInfo()
    }

    func downloadFailed(item: DownloadItem) {
        let index: Int? = self.needBeDownloadedList.indexOf { (tmp) -> Bool in
            tmp.sourceUrl == item.sourceUrl
        }
        if let index = index {
            self.needBeDownloadedList.removeAtIndex(index)
        }
        self.failedList.append(item)

        self.saveInfo()
    }

    func addDownloadItem(item: DownloadItem) {
        if self.isSuccessDownloaded(item.sourceUrl) {
            AppInfo.showToast("此文件已经下载")
            return
        }
        else if self.isInToBeDownload(item.sourceUrl) {
            AppInfo.showToast("文件正在队列中")
            return
        }
        self.checkAndAddToQueue(item)
        AppInfo.showToast("成功加入下载队列中")

        self.downloadNext()
        self.saveInfo()
    }

    func removeItem(item: DownloadItem) {
        var index: Int? = self.needBeDownloadedList.indexOf { (tmp) -> Bool in
            tmp.sourceUrl == item.sourceUrl
        }
        if let index = index {
            self.needBeDownloadedList.removeAtIndex(index)
        }
        index = self.failedList.indexOf { (tmp) -> Bool in
            tmp.sourceUrl == item.sourceUrl
        }
        if let index = index {
            self.failedList.removeAtIndex(index)
        }
        index = self.downloadedList.indexOf { (tmp) -> Bool in
            tmp.sourceUrl == item.sourceUrl
        }
        if let index = index {
            self.downloadedList.removeAtIndex(index)
        }
        item.removeSource()
        self.saveInfo()
    }

    subscript(index: Int) -> DownloadItem? {
        if index >= self.needBeDownloadedList.count + self.failedList.count + self.downloadedList.count {
            return nil
        }

        if index < self.needBeDownloadedList.count {
            return self.needBeDownloadedList[index]
        }
        else if index < self.needBeDownloadedList.count + self.downloadedList.count {
            return self.downloadedList[index - self.needBeDownloadedList.count]
        }
        else {
            return self.failedList[index - self.needBeDownloadedList.count - self.downloadedList.count]
        }
    }

    var countOfDownloadList: Int {
        return self.needBeDownloadedList.count + self.failedList.count + self.downloadedList.count
    }
}

func performForCheckDownLoad(userId: String, InfoId: String, scoreNum: Int) -> SignalProducer<(ReturnMsg?, Bool), ServiceError> {
    return DefaultServiceRequests.rac_requesForCheckDownloadStatus(userId, infoId: InfoId, scoreNum: scoreNum)
        .map({ (object) in
            let returnMsg = ReturnMsg.mapToModel(object)
            if let msg = returnMsg {
                if msg.isSuccess {
                    //0 可以下载
                    if let s = mapToString(object)("Result") {
                        return (msg, s == "0")
                    }
                    return (msg, false)
                }
                else {
                    return (msg, false)
                }
            }
            else {
                return (nil, false)
            }

        })
}

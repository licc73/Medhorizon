//
//  DownloadManager.swift
//  Medhorizon
//
//  Created by lich on 10/12/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

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

struct DownloadItem {
    let sourceUrl: String
    let fileType: Int
    let picUrl: String
    let status: Int
    let title: String
    var progress: Double
}

extension DownloadItem {
    static func mapToSelf(dictionary: [String: AnyObject]) -> DownloadItem? {
        let stringMap = mapToString(dictionary)
        let intMap = mapToInt(dictionary)
        if let sourceUrl = stringMap(downloadSourceUrlKey),
            fileType = intMap(downloadFileTypeKey),
            picUrl = stringMap(downloadPicUrlKey),
            status = intMap(downloadStatusKey),
            title = stringMap(downloadTitleUrlKey),
            progress = mapToDouble(dictionary)(downloadProgressKey) {
            return DownloadItem(sourceUrl: sourceUrl, fileType: fileType, picUrl: picUrl, status: status, title: title, progress: progress)
        }
        return nil
    }

    func mapToFlatten() -> [String: AnyObject] {
        return [downloadSourceUrlKey: self.sourceUrl,
                downloadFileTypeKey: self.fileType,
                downloadPicUrlKey: self.picUrl,
                downloadStatusKey: self.status,
                downloadTitleUrlKey: self.title,
                downloadProgressKey: self.progress]
    }
}

let documentFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
let downloadManagerFile = "downloadlist.plist"

func curUserFolder() -> String {
    guard let userId = LoginManager.shareInstance.userId else {
        return documentFolder + "/" + "0"
    }
    return documentFolder + "/" + "\(userId)"
}

func downloadManagerFilePath() -> String {
    return curUserFolder() + "/" + downloadManagerFile
}

func downloadFileFolder() -> String {
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

    func reloadData() {
        self.downloadedList.removeAll()
        self.needBeDownloadedList.removeAll()
        self.failedList.removeAll()

        guard LoginManager.shareInstance.isLogin else {
            return
        }

        let downloadFile = downloadManagerFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(downloadFile) {
            createFolder(downloadFileFolder())
            if let downloadListPlist = NSArray(contentsOfFile: downloadFile) as? [[String: AnyObject]] {
                let downloadList = downloadListPlist.flatMap({ (object) -> DownloadItem? in
                    return DownloadItem.mapToSelf(object)
                })

                for item in downloadList {
                    if item.status == 1 {

                    }
                }
            }

        }
        else {
            createFolder(curUserFolder())
            createFolder(downloadFileFolder())
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
        let index: Int? = self.failedList.indexOf { (tmp) -> Bool in
            tmp.sourceUrl == item.sourceUrl
        }
        if let index = index {
            self.failedList.removeAtIndex(index)
        }
        self.needBeDownloadedList.append(item)
    }

    func downloadNext() {
        if self.isDownloading {

        }
        else {

        }
    }

    func downloadSuc(item: DownloadItem) {
        let index: Int? = self.needBeDownloadedList.indexOf { (tmp) -> Bool in
            tmp.sourceUrl == item.sourceUrl
        }
        if let index = index {
            self.needBeDownloadedList.removeAtIndex(index)
        }
        self.downloadedList.append(item)
        
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

        self.downloadNext()
    }
}

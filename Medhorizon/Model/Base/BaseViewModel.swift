//
//  BaseViewModel.swift
//  Medhorizon
//
//  Created by lich on 10/9/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

final class Branner {
    let id: String
    let title: String?
    let linkUrl: String
    let picUrl: String?
    
    init(id: String, title: String?, linkUrl: String, picUrl: String?) {
        self.id = id
        self.title = title
        self.linkUrl = linkUrl
        self.picUrl = picUrl
    }
    
}

extension Branner: ViewModel {

    static func mapToModel(dictionary: [String: AnyObject]) -> Branner? {
        let stringMap = mapToString(dictionary)
        if let id = stringMap("BrannerId"), linkUrl = stringMap("BrannerLinkUrl") {
            return Branner(id: id, title: stringMap("BrannerTitle"), linkUrl: linkUrl, picUrl: stringMap("BrannerPicUrl"))
        }
        return nil
    }
    
}

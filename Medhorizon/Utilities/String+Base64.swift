//
//  String+Base64.swift
//  iOSLMV
//
//  Created by RonnieRen on 11/4/15.
//  Copyright © 2015 Autodesk. All rights reserved.
//

import Foundation


extension String {
    
    func toBase64() -> String? {
        return  self.dataUsingEncoding(NSUTF8StringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    
    func dataFromBase64() -> NSData? {
        return  NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
    }
    
    
    func fromBase64() -> String? {
        if let data = self.dataFromBase64() {
            return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
        }
        return nil
    }
    
    
}

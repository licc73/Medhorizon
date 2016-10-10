//
//  UIExtension.swift
//  Medhorizon
//
//  Created by lich on 10/9/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    func makeImageAndTitleUpDown(spacing: CGFloat = 3) {
        guard let imgView = self.imageView, label = self.titleLabel else {
            return
        }
        
        let imageSize = imgView.frame.size
        let titleSize = label.frame.size
        
//        let attrs = [NSFontAttributeName : label.font]
//        
//        let textSize = label.text!.boundingRectWithSize(CGSize(width: 1000, height: 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attrs, context: nil).size
//        
//        let frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height))
//        
//        if titleSize.width + 0.5 < frameSize.width {
//            titleSize.width = frameSize.width;
//        }
        
        let totalHeight = imageSize.height + titleSize.height + spacing
        self.imageEdgeInsets = UIEdgeInsetsMake(0 - (totalHeight - imageSize.height), 0.0, 0.0, 0 - titleSize.width);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0 - imageSize.width, 0 - (totalHeight - titleSize.height), 0);


    }
    
}

extension UIColor {
    
    static func colorWithHex(hex: UInt32, alpha: CGFloat = 1) -> UIColor {
        let r = (hex & 0xFF0000) >> 16;
        let g = (hex & 0x00FF00) >> 8;
        let b = (hex & 0x0000FF);
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    static func colorWithHexString(hexString: String, alpha: CGFloat = 1) -> UIColor {
        let scanner = NSScanner(string: hexString)
        var hex: UInt32 = 0
        scanner.scanHexInt(&hex)
        return UIColor.colorWithHex(hex, alpha: alpha)
    }
    
}

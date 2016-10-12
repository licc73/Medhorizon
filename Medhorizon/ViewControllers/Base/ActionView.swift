//
//  ActionView.swift
//  Medhorizon
//
//  Created by ZongBo Zhou on 10/12/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

enum ActionType {
    case Share
    case Fav
    case Comment
    case Download
}

class ActionView: UIView {
    let txtComment: UITextField
    let btnComment: UIButton
    let btnFav: UIButton
    let btnDownload: UIButton
    let btnShare: UIButton
    
    override init(frame: CGRect) {
        self.txtComment = UITextField(frame: CGRectZero)
        self.btnComment = UIButton(type: .Custom)
        self.btnFav = UIButton(type: .Custom)
        self.btnDownload = UIButton(type: .Custom)
        self.btnShare = UIButton(type: .Custom)
        super.init(frame: frame)
        
        self.setButton(self.btnComment, image: "")
        self.setButton(self.btnFav, image: "")
        self.setButton(self.btnDownload, image: "")
        self.setButton(self.btnShare, image: "")
    }
    
    private func setButton(button: UIButton, image: String) {
        button.setImage(UIImage(named: image), forState: .Normal)
        button.addTarget(self, action: #selector(actionOnClicked(_:)), forControlEvents: .TouchUpInside)
        button.hidden = true
        self.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func actionOnClicked(button: UIButton) {
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

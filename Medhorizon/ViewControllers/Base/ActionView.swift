//
//  ActionView.swift
//  Medhorizon
//
//  Created by lich on 10/12/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

enum ActionType {
    case None
    case Share
    case Fav
    case Comment
    case Download
}

protocol ActionViewDelegate: class {
    func actionViewShouldBeginAddComment(view view: ActionView) -> Bool
    func actionView(view view: ActionView, willSend comment: String) -> Bool
    func actionView(view view: ActionView, didSelectAction type: ActionType)
}

class ActionView: UIView {
    let offset: CGFloat = 15
    let actionWidth: CGFloat = 30
    let actionGapSpace: CGFloat = 4
    
    let txtComment: UITextField
    let btnComment: UIButton
    let btnFav: UIButton
    let btnDownload: UIButton
    let btnShare: UIButton
    
    var delegate: ActionViewDelegate?
    
    override init(frame: CGRect) {
        self.txtComment = UITextField(frame: CGRectZero)
        self.btnComment = UIButton(type: .Custom)
        self.btnFav = UIButton(type: .Custom)
        self.btnDownload = UIButton(type: .Custom)
        self.btnShare = UIButton(type: .Custom)
        super.init(frame: CGRectMake(0, 0, AppInfo.screenWidth, 44))
        
        self.txtComment.borderStyle = .RoundedRect
        self.txtComment.delegate = self
        self.txtComment.returnKeyType = UIReturnKeyType.Send
        self.txtComment.enablesReturnKeyAutomatically = true
        self.txtComment.placeholder = "向专家提问"
        self.txtComment.font = UIFont.systemFontOfSize(16)
        
        self.addSubview(self.txtComment)
        
        self.setButton(self.btnComment, image: "comment")
        self.setButton(self.btnFav, image: "star")
        self.setButton(self.btnDownload, image: "icon_download")
        self.setButton(self.btnShare, image: "share")
        
        let imgvHLine = UIImageView(frame: CGRectMake(0, 0, AppInfo.screenWidth, 0.5))
        imgvHLine.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(imgvHLine)
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
    
    func setFav(isFav: Bool) {
        if isFav {
            self.btnFav.setImage(UIImage(named: "fav_sel"), forState: .Normal)
        }
        else {
            self.btnFav.setImage(UIImage(named: "star"), forState: .Normal)
        }
    }
    
    func config(types: [ActionType]) {
        self.txtComment.frame = CGRectMake(offset, 7, AppInfo.screenWidth - CGFloat(types.count) * (actionWidth + actionGapSpace) - offset * 2, 30)
        var iCurType: CGFloat = 0
        for type in types {
            switch type {
            case .Share:
                self.btnShare.hidden = false
                self.btnShare.frame = CGRectMake(offset + CGRectGetWidth(self.txtComment.frame) + actionGapSpace + (actionGapSpace + actionWidth) * iCurType, 7, actionWidth, actionWidth)
            case .Fav:
                self.btnFav.hidden = false
                self.btnFav.frame = CGRectMake(offset + CGRectGetWidth(self.txtComment.frame) + actionGapSpace + (actionGapSpace + actionWidth) * iCurType, 7, actionWidth, actionWidth)
            case .Comment:
                self.btnComment.hidden = false
                self.btnComment.frame = CGRectMake(offset + CGRectGetWidth(self.txtComment.frame) + actionGapSpace + (actionGapSpace + actionWidth) * iCurType, 7, actionWidth, actionWidth)
            case .Download:
                self.btnDownload.hidden = false
                self.btnDownload.frame = CGRectMake(offset + CGRectGetWidth(self.txtComment.frame) + actionGapSpace + (actionGapSpace + actionWidth) * iCurType, 7, actionWidth, actionWidth)
            default:
                break
            }
            iCurType += 1
        }
    }
    
    func actionOnClicked(button: UIButton) {
        var type: ActionType = .None
        if button == self.btnFav {
            type = .Fav
        }
        else if button == self.btnShare {
            type = .Share
        }
        else if button == self.btnComment {
            type = .Comment
        }
        else if button == self.btnDownload {
            type = .Download
        }
        
        self.delegate?.actionView(view: self, didSelectAction: type)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

extension ActionView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return self.delegate?.actionViewShouldBeginAddComment(view: self) ?? false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let commentText = textField.text {
            if !commentText.isEmpty {
                if let result = self.delegate?.actionView(view: self, willSend: commentText) {
                    if result {
                        textField.text = nil
                    }
                    return result
                }
                
            }
        }
        return false
    }
    
}

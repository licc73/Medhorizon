//
//  Courseware.swift
//  Medhorizon
//
//  Created by lichangchun on 10/12/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

enum CoursewareType: Int {
    case Video          = 1
    case Document       = 2
    case ExcelentCase   = 3
}

protocol ChooseCoursewareViewDelegate: class {
    func chooseCoursewareView(view: ChooseCoursewareView, chooseType type: CoursewareType)
}

class ChooseCoursewareView: UIView {
    let btnVideo: UIButton
    let btnDocument: UIButton
    let btnExcelentCase: UIButton
    
    weak var delegate: ChooseCoursewareViewDelegate?
    
    override init(frame: CGRect) {
        let offset: CGFloat = 12
        let gap: CGFloat = 9
        let buttonWidth = (AppInfo.screenWidth - offset * 2 - gap * 2) / 3
        
        self.btnVideo = UIButton(type: .Custom)
        self.btnDocument = UIButton(type: .Custom)
        self.btnExcelentCase = UIButton(type: .Custom)
        super.init(frame: CGRectMake(0, frame.origin.y, AppInfo.screenWidth, buttonWidth + 10))
        
        self.btnVideo.frame = CGRectMake(offset, 5, buttonWidth, buttonWidth)
        self.btnDocument.frame = CGRectMake(offset + gap + buttonWidth, 5, buttonWidth, buttonWidth)
        self.btnExcelentCase.frame = CGRectMake(offset + (gap + buttonWidth) * 2, 5, buttonWidth, buttonWidth)
        self.setButton(self.btnVideo, normalImage: "button_course_type_video", selectedImage: "button_course_type_video_sel")
        self.setButton(self.btnDocument, normalImage: "button_course_type_document", selectedImage: "button_course_type_document_sel")
        self.setButton(self.btnExcelentCase, normalImage: "button_course_type_excelent", selectedImage: "button_course_type_excelent_sel")
        self.type = .Video
        self.btnVideo.selected = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var type: CoursewareType = .Video {
        didSet {
            self.btnExcelentCase.selected = false
            self.btnDocument.selected = false
            self.btnVideo.selected = false
            switch type {
            case .Video:
                self.btnVideo.selected = true
            case .Document:
                self.btnDocument.selected = true
            case .ExcelentCase:
                self.btnExcelentCase.selected = true
            }
        }
    }
    
    private func setButton(button: UIButton, normalImage: String, selectedImage: String) {
        button.setBackgroundImage(UIImage(named: normalImage), forState: .Normal)
        button.setBackgroundImage(UIImage(named: selectedImage), forState: .Selected)
        button.addTarget(self, action: #selector(buttonOnClicked(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(button)
    }
    
    
    func buttonOnClicked(button: UIButton) {
        if button == self.btnVideo {
            self.type = .Video
        }
        else if button == self.btnDocument {
            self.type = .Document
        }
        else if button == self.btnExcelentCase {
            self.type = .ExcelentCase
        }
        self.delegate?.chooseCoursewareView(self, chooseType: self.type)
    }
}

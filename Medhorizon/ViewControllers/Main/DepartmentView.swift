//
//  DepartmentView.swift
//  Medhorizon
//
//  Created by lich on 10/9/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

enum DepartmentType: Int {
    case Child          = 1
    case Internal       = 2
    case Dermatology    = 3
    case Other          = 4

    func getResource() -> (String, String, String) {
        switch self {
        case .Child:
            return ("儿科", "icon_pediatrics_unsel", "icon_pediatrics_sel")
        case .Internal:
            return ("内科", "icon_internal_medicine_unsel", "icon_internal_medicine_sel")
        case .Dermatology:
            return ("皮科", "icon_dermatology_unsel", "icon_dermatology_sel")
        case .Other:
            return ("全科", "icon_others_unsel", "icon_others_sel")
        }
    }
}

class DepartmentDisplayView: UIView {
    let imgvIcon: UIImageView
    let labTitle: UILabel
    let imgvArrow: UIImageView

    override init(frame: CGRect) {
        self.imgvIcon = UIImageView(frame: CGRectMake(0, 14, 17, 17))
        self.labTitle = UILabel(frame: CGRectMake(20, 0, 50, 44))
        self.imgvArrow = UIImageView(frame: CGRectMake(80, 20, 9, 4.5))
        super.init(frame: CGRectMake(0, 0, 85, 44))
        self.addSubview(self.imgvIcon)
        self.addSubview(self.labTitle)
        self.addSubview(self.imgvArrow)
        self.imgvArrow.image = UIImage(named: "icon_arrow_down")
        self.imgvIcon.image = UIImage(named: "icon_pediatrics_sel")
        self.labTitle.textAlignment = .Center
        self.labTitle.text = "儿科"
        self.labTitle.font = UIFont.systemFontOfSize(17)
        self.labTitle.textColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDepartmentType(department: DepartmentType) {
        let (title, _, selImg) = department.getResource()
        self.imgvIcon.image = UIImage(named: selImg)
        self.labTitle.text = title
    }

}

protocol DepartmentChooseViewDelegate: class {
    func departmentChooseView(view: DepartmentChooseView, choose type: DepartmentType)
}

class DepartmentChooseView: UIView {
    let vChoose: UIView

    let childButton: UIButton
    let internalButton: UIButton
    let dermatologyButton: UIButton
    let otherButton: UIButton

    weak var delegate: DepartmentChooseViewDelegate?
    
    let vPrompt: UIView

    override init(frame: CGRect) {
        self.vChoose = UIView(frame: CGRectMake(0, 0, AppInfo.screenWidth, 60))
        self.childButton = UIButton(type: .Custom)
        self.internalButton = UIButton(type: .Custom)
        self.dermatologyButton = UIButton(type: .Custom)
        self.otherButton = UIButton(type: .Custom)

        self.vPrompt = UIView(frame: CGRectMake(0, 0, AppInfo.screenWidth, AppInfo.screenHeight))
        
        super.init(frame: UIScreen.mainScreen().bounds)
        self.addSubview(self.vPrompt)
        self.addSubview(self.vChoose)

        let buttonWidth = AppInfo.screenWidth / 4.0
        self.childButton.frame = CGRectMake(0, 0, buttonWidth, 60)
        self.vChoose.addSubview(self.childButton)
        self.setButtonDisplay(self.childButton, department: .Child)

        self.internalButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, 60)
        self.vChoose.addSubview(self.internalButton)
        self.setButtonDisplay(self.internalButton, department: .Internal)

        self.dermatologyButton.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, 60)
        self.vChoose.addSubview(self.dermatologyButton)
        self.setButtonDisplay(self.dermatologyButton, department: .Dermatology)

        self.otherButton.frame = CGRectMake(buttonWidth * 3, 0, buttonWidth, 60)
        self.vChoose.addSubview(self.otherButton)
        self.setButtonDisplay(self.otherButton, department: .Other)

        let imgvVLine1 = UIImageView(frame: CGRectMake(buttonWidth, 0, 0.5, 60))
        imgvVLine1.backgroundColor = UIColor.colorWithHex(0xd8ebf6)
        self.vChoose.addSubview(imgvVLine1)

        let imgvVLine2 = UIImageView(frame: CGRectMake(buttonWidth * 2, 0, 0.5, 60))
        imgvVLine2.backgroundColor = UIColor.colorWithHex(0xd8ebf6)
        self.vChoose.addSubview(imgvVLine2)

        let imgvVLine3 = UIImageView(frame: CGRectMake(buttonWidth * 3, 0, 0.5, 60))
        imgvVLine3.backgroundColor = UIColor.colorWithHex(0xd8ebf6)
        self.vChoose.addSubview(imgvVLine3)

        let imgvHLine = UIImageView(frame: CGRectMake(0, 59.5, AppInfo.screenWidth, 0.5))
        imgvHLine.backgroundColor = UIColor.colorWithHex(0xd8d8d8)
        self.vChoose.addSubview(imgvHLine)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideSelf(_:)))
        self.addGestureRecognizer(gesture)
        
        self.vPrompt.backgroundColor = UIColor.colorWithHex(0, alpha: 0.5)
        let imgvPrompt = UIImageView(frame: CGRectMake(AppInfo.screenWidth / 2 - 27 / 2, 20, 27, 27))
        imgvPrompt.image = UIImage(named: "arrow")
        let label = UILabel(frame: CGRectMake(0, 50, AppInfo.screenWidth, 27))
        label.text = "请选择科室"
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(18)        
        self.vPrompt.addSubview(imgvPrompt)
        self.vPrompt.addSubview(label)
    }

    private func setButtonDisplay(button: UIButton, department: DepartmentType) {
        let (title, normalImg, selImg) = department.getResource()
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.colorWithHex(0x2892cb), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)

        button.setImage(UIImage(named: normalImg), forState: .Normal)
        button.setImage(UIImage(named: selImg), forState: .Selected)

        button.setBackgroundImage(UIImage(named: "department_unsel_bg"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "department_sel_bg"), forState: .Selected)

        button.addTarget(self, action: #selector(buttonOnClicked(_:)), forControlEvents: .TouchUpInside)

        button.makeImageAndTitleUpDown()
    }

    func buttonOnClicked(button: UIButton) {
        var type = DepartmentType.Child
        if button == self.childButton {
            type = .Child
        }
        else if button == self.internalButton {
            type = .Internal
        }
        else if button == self.dermatologyButton {
            type = .Dermatology
        }
        else if button == self.otherButton {
            type = .Other
        }
        self.selectType(type)
        self.delegate?.departmentChooseView(self, choose: type)
        self.dismiss()
    }

    private func selectType(type: DepartmentType) {
        childButton.selected = false
        dermatologyButton.selected = false
        internalButton.selected = false
        otherButton.selected = false
        switch type {
        case .Child:
            childButton.selected = true
        case .Internal:
            internalButton.selected = true
        case .Dermatology:
            dermatologyButton.selected = true
        case .Other:
            otherButton.selected = true
        }
    }

    func dismiss() {
        self.vPrompt.removeFromSuperview()
        self.removeFromSuperview()
    }

    func show(height: CGFloat, type: DepartmentType, prompt: Bool) {
        self.vChoose.frame = CGRectMake(0, height, AppInfo.screenWidth, 60)
        self.vPrompt.frame = CGRectMake(0, height + 60, AppInfo.screenWidth, AppInfo.screenHeight)
        self.selectType(type)
    }

    func hideSelf(gesture: UITapGestureRecognizer) {
        self.dismiss()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

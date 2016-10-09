//
//  DepartmentView.swift
//  Medhorizon
//
//  Created by ZongBo Zhou on 10/9/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class DepartmentDisplayView: UIView {

    let imgvIcon: UIImageView
    let labTitle: UILabel
    let imgvArrow: UIImageView

    override init(frame: CGRect) {
        self.imgvIcon = UIImageView(frame: CGRectMake(0, 14, 16, 16))
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
        self.labTitle.font = UIFont.systemFontOfSize(16)
        self.labTitle.textColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(icon: UIImage, title: String) {
        self.imgvIcon.image = icon
        self.labTitle.text = title
    }

}


class DepartmentChooseView: UIView {

    let vChoose: UIView

    let childButton: UIButton
    let internalButton: UIButton
    let dermatologyButton: UIButton
    let otherButton: UIButton

    override init(frame: CGRect) {
        <#code#>
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

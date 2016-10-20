//
//  MainTabbarViewController.swift
//  Medhorizon
//
//  Created by lich on 10/8/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class MainTabbarViewController: UITabBarController {
    var titleView: DepartmentDisplayView?
    var chooseView: DepartmentChooseView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        LoginManager.shareInstance.mainCtrl = self
        
        self.setDisplay()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setDisplay() {
        self.tabBar.tintColor = UIColor.colorWithHex(0x2892cb)
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_main_userInfo"), style: .Plain, target: self, action: #selector(enterUserInfo(_:)))

        self.titleView = DepartmentDisplayView(frame: CGRectMake(0, 0, 100, 44))
        let gesture = UITapGestureRecognizer(target: self, action: #selector(titleViewOnClicked(_:)))
        self.titleView?.addGestureRecognizer(gesture)
        self.titleView?.setDepartmentType(GlobalData.shareInstance.departmentId.value)
        
        let rightButton1 = UIBarButtonItem(image: UIImage(named: "icon_setting"), style: .Plain, target: self, action: #selector(setup(_:)))
        let rightButton2 = UIBarButtonItem(image: UIImage(named: "icon_medical"), style: .Plain, target: self, action: #selector(medicalOnClicked(_:)))
        self.navigationItem.setRightBarButtonItems([rightButton1, rightButton2], animated: false)

        self.navigationItem.titleView = self.titleView

        self.chooseView = DepartmentChooseView(frame: CGRectZero)
        self.chooseView?.delegate = self
        self.showChooseView(true)
    }
//
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        if let nav = self.navigationController as? EdgeNavigationViewController {
//            nav.canDragBack = false
//        }
//    }
//
//    override func viewDidDisappear(animated: Bool) {
//        super.viewDidDisappear(animated)
//        if let nav = self.navigationController as? EdgeNavigationViewController {
//            nav.canDragBack = true
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainTabbarViewController {

    func showChooseView(prompt: Bool = false) {
        if let view = self.chooseView {
            UIApplication.sharedApplication().keyWindow?.addSubview(view)
            self.chooseView?.show(64, type: GlobalData.shareInstance.departmentId.value, prompt: prompt)
        }
    }

    func titleViewOnClicked(gesture: UITapGestureRecognizer) {
        self.showChooseView()
    }

}

extension MainTabbarViewController: DepartmentChooseViewDelegate {

    func departmentChooseView(view: DepartmentChooseView, choose type: DepartmentType) {
        self.titleView?.setDepartmentType(type)
        GlobalData.shareInstance.saveDepartment(type)
    }

}

extension MainTabbarViewController {

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}

extension MainTabbarViewController {

    func enterUserInfo(sender: AnyObject) {
        LoginManager.loginOrEnterUserInfo()
    }
    
    func setup(sender: AnyObject) {
        self.performSegueWithIdentifier(StoryboardSegue.Main.ShowSetupView.rawValue, sender: nil)
    }
    
    func medicalOnClicked(sender: AnyObject) {
        AppInfo.showToast("开发中，敬请期待")
    }
    
}

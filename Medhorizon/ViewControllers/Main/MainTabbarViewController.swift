//
//  MainTabbarViewController.swift
//  Medhorizon
//
//  Created by ZongBo Zhou on 10/8/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class MainTabbarViewController: UITabBarController {
    var titleView: DepartmentDisplayView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setDisplay()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setDisplay() {
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_main_userInfo"), style: .Plain, target: self, action: #selector(enterUserInfo(_:)))

        self.titleView = DepartmentDisplayView(frame: CGRectMake(0, 0, 100, 44))
        self.navigationItem.titleView = self.titleView
    }

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

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}

extension MainTabbarViewController {

    func enterUserInfo(sender: AnyObject) {
        
    }
    
}

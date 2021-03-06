//
//  TourViewController.swift
//  Medhorizon
//
//  Created by lich on 10/8/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class TourViewController: UIViewController {

    @IBOutlet weak var btnHome: UIButton!
    
    var timer: NSTimer?
    
    let totalCount = 2
    var currentCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBarHidden = true
        
        self.setHomeButtonText()
        self.btnHome.setTitleColor(UIColor.colorWithHex(0x2892cb), forState: .Normal)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(timerSelector(_:)), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerSelector(timer: NSTimer) {
        guard currentCount != totalCount else {
            self.jumpToHome()
            return
        }
        self.currentCount += 1
        self.setHomeButtonText()
    }
    
    private func setHomeButtonText() {
        self.btnHome.setTitle(String(format: "跳过%ds", totalCount - currentCount), forState: .Normal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if let nav = self.navigationController as? EdgeNavigationViewController {
            nav.removeSubViewController(self, isActionPush: true)
        }
    }

}

extension TourViewController {
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
//    
//    override func prefersStatusBarHidden() -> Bool {
//        return false
//    }
}

extension TourViewController {
    func jumpToHome() {
        self.timer?.invalidate()
        self.performSegueWithIdentifier(StoryboardSegue.Main.Main.rawValue, sender: nil)
    }
    
    @IBAction func homeOnClicked() {
        self.jumpToHome()
    }
}

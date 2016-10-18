//
//  ChangeNickNameViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ChangeNickNameViewController: UIViewController {
    @IBOutlet weak var txtNickName: UITextField!
    @IBOutlet weak var btnConfirm: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.txtNickName.leftView = UIImageView(image: UIImage(named: "icon_txt_left_clear_view"))
        self.txtNickName.setupDefaultDisplay()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(gesture)
        let loginInfo = LoginManager.shareInstance.loginInfo
        self.txtNickName.text = loginInfo?.nickName
        self.setupBind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBind() {

        let nickSP = self.txtNickName.rac_textSignal()
            .toSignalProducer()
            .map { (object) -> Bool in
                if let s = object as? String {
                    if s.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                        return true
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
        }

        nickSP
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on {[unowned self] (b) in
                self.btnConfirm.enabled = b
            }
            .start()
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

extension ChangeNickNameViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func confirm(sender: AnyObject) {
        guard let nickName = self.txtNickName.text, userId = LoginManager.shareInstance.userId else {
            return
        }

        LoginManager.performModifyNickName(userId, nickName: nickName)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on( failed: { (_) in
                AppInfo.showDefaultNetworkErrorToast()
                }, next: {[unowned self] (returnMsg) in
                    if let msg = returnMsg {
                        if msg.isSuccess {
                            let loginInfo = LoginManager.shareInstance.loginInfo
                            loginInfo?.nickName = nickName
                            let detail = LoginManager.shareInstance.userDetailInfo
                            detail?.nickName = nickName
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                        else {
                            AppInfo.showToast(msg.errorMsg)
                        }
                    }
                    else {
                        AppInfo.showToast("未知错误")
                    }
            })
            .start()
    }

    func dismissKeyboard(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}

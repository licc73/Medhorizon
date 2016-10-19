//
//  TrueNameVerifyViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

enum TrueNameType: Int {
    case WWID = 1
    case Doctor = 2
}

class TrueNameVerifyViewController: UIViewController {
    @IBOutlet weak var labType: UILabel!
    @IBOutlet weak var txtType: UITextField!

    @IBOutlet weak var txtWWID: UITextField!
    @IBOutlet weak var btnWWID: UIButton!


    @IBOutlet weak var txtHospital: UITextField!
    @IBOutlet weak var txtDepartment: UITextField!
    @IBOutlet weak var txtJob: UITextField!
    @IBOutlet weak var btnDoctor: UIButton!

    var type: TrueNameType = .WWID {
        didSet {
            self.showType()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(gesture)
        
        self.configDisplay()
        self.setupBind()

        let detail = LoginManager.shareInstance.userDetailInfo
        if let detail = detail {
            if let w = detail.WWID where w != "" {
                self.type = .WWID
                self.txtWWID.text = w
            }
            else if let b = detail.isTrueName where b {
                self.type = .Doctor
                self.txtHospital.text = detail.hospital
                self.txtDepartment.text = detail.department
                self.txtJob.text = detail.job
            }
            else {
                self.type = .WWID
            }
        }
    }

    func configDisplay() {
        let imgLeftClear = UIImage(named: "icon_txt_left_clear_view")
        self.txtType.leftView = UIImageView(image: imgLeftClear)
        self.txtType.setupDefaultDisplay()

        self.txtWWID.leftView = UIImageView(image: imgLeftClear)
        self.txtWWID.setupDefaultDisplay()

        self.txtHospital.leftView = UIImageView(image: imgLeftClear)
        self.txtHospital.setupDefaultDisplay()

        self.txtDepartment.leftView = UIImageView(image: imgLeftClear)
        self.txtDepartment.setupDefaultDisplay()

        self.txtJob.leftView = UIImageView(image: imgLeftClear)
        self.txtJob.setupDefaultDisplay()
    }

    func showType() {
        switch type {
        case .WWID:
            self.txtWWID.hidden = false
            self.btnWWID.hidden = false
            self.txtHospital.hidden = true
            self.txtJob.hidden = true
            self.txtDepartment.hidden = true
            self.btnDoctor.hidden = true
            self.labType.text = "强生员工"
            self.txtType.text = "强生员工"
        case .Doctor:
            self.txtWWID.hidden = true
            self.btnWWID.hidden = true
            self.txtHospital.hidden = false
            self.txtJob.hidden = false
            self.txtDepartment.hidden = false
            self.btnDoctor.hidden = false
            self.labType.text = "医生"
            self.txtType.text = "医生"
        }
    }

    func setupBind() {
        let checkValidContentMapping: AnyObject? -> Bool = { (object) -> Bool in
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

        let checkWWID = self.txtWWID.rac_textSignal()
            .toSignalProducer()
            .map (checkValidContentMapping)
        let checkHospital = self.txtHospital.rac_textSignal()
            .toSignalProducer()
            .map (checkValidContentMapping)
        let checkDepartment = self.txtDepartment.rac_textSignal()
            .toSignalProducer()
            .map (checkValidContentMapping)
        let checkJob = self.txtJob.rac_textSignal()
            .toSignalProducer()
            .map (checkValidContentMapping)

        checkWWID
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on {[unowned self] (isValidWWID) in
                self.btnWWID.enabled = isValidWWID
            }
            .start()

        combineLatest(checkHospital, checkDepartment, checkJob)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on {[unowned self] (valid) in
                self.btnDoctor.enabled = valid.0 && valid.1 && valid.2
            }
            .start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TrueNameVerifyViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func chooseType(sender: AnyObject) {
        let actionController = UIAlertController(title: nil,
                                                 message:"请选择",
                                                 preferredStyle: UIAlertControllerStyle.ActionSheet)

        actionController.addAction(UIAlertAction(title: "强生员工",
            style: UIAlertActionStyle.Default, handler: {[unowned self](action) -> Void in
                self.type = .WWID
        }))

        actionController.addAction(UIAlertAction(title: "医生",
            style: UIAlertActionStyle.Default, handler: {[unowned self](action) -> Void in
                self.type = .Doctor
            }))

        actionController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in

        }))

        self.presentViewController(actionController, animated: true, completion: nil)
    }

    @IBAction func confirmDoctor(sender: AnyObject) {
        self.view.endEditing(true)
        guard let userId = LoginManager.shareInstance.userId, hospital = self.txtHospital.text, department = self.txtDepartment.text, job = self.txtJob.text else {
            return
        }

        LoginManager.performForTrueName(userId, type: self.type, wwid: nil, doctor: (hospital, department, job))
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on( failed: { (_) in
                AppInfo.showDefaultNetworkErrorToast()
                }, next: {[unowned self] (returnMsg) in
                    if let msg = returnMsg {
                        if msg.isSuccess {
                            AppInfo.showToast("修改成功")
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

    @IBAction func confirmWWID(sender: AnyObject) {
        self.view.endEditing(true)
        guard let userId = LoginManager.shareInstance.userId,  wwid = self.txtWWID.text else {
            return
        }

        LoginManager.performForTrueName(userId, type: self.type, wwid: wwid, doctor: nil)
            .takeUntil(self.rac_WillDeallocSignalProducer())
            .observeOn(UIScheduler())
            .on( failed: { (_) in
                AppInfo.showDefaultNetworkErrorToast()
                }, next: {[unowned self] (returnMsg) in
                    if let msg = returnMsg {
                        if msg.isSuccess {
                            AppInfo.showToast("修改成功")
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

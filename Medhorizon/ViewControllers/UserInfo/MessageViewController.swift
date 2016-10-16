//
//  MessageViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var btnMyMessage: UIButton!
    @IBOutlet weak var vMyMessage: UIView!

    @IBOutlet weak var btnSysMessage: UIButton!
    @IBOutlet weak var vSysMessage: UIView!

    enum MessageViewControllerShowType {
        case My
        case Sys
    }

    var messageType = MessageViewControllerShowType.My {
        didSet {
            self.setupDisplay()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        messageType = .My
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDisplay() {
        switch messageType {
        case .My:
            self.btnMyMessage.selected = true
            self.btnSysMessage.selected = false
            self.vMyMessage.hidden = false
            self.vSysMessage.hidden = true
        case .Sys:
            self.btnMyMessage.selected = false
            self.btnSysMessage.selected = true
            self.vMyMessage.hidden = true
            self.vSysMessage.hidden = false
        }
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

extension MessageViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func myMessageOnClicked(sender: AnyObject) {
        self.messageType = .My
    }

    @IBAction func sysMessageOnClicked(sender: AnyObject) {
        self.messageType = .Sys
    }
    
}

//
//  SettingViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/16/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
/// Hard Code current page for saving time.

class SettingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let id = segue.identifier where id == StoryboardSegue.Main.ShowNormalLink.rawValue {
            if let destination = segue.destinationViewController as? NormalLinkViewController {
                destination.linkUrl = privatePolicyUrl
                destination.title = "隐私声明"
            }
        }

    }


}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("SetupWithSwichTableViewCell", forIndexPath: indexPath) as! SetupWithSwichTableViewCell
            cell.setTitle("仅WIFI下播放", isOn: SetupValueManager.shareInstance.isPlayInWifiOnly)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("SetupWithSwichTableViewCell", forIndexPath: indexPath) as! SetupWithSwichTableViewCell
            cell.setTitle("进入播放页面自动播放", isOn: SetupValueManager.shareInstance.isPlayWhenOpen)
            cell.delegate = self
            return cell
        case 2:
            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.textLabel?.text = "隐私声明"
            return cell

        default:
            return UITableViewCell()
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "流量设置"
        case 1:
            return "播放设置"
        default:
            return nil
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            self.performSegueWithIdentifier(StoryboardSegue.Main.ShowNormalLink.rawValue, sender: nil)
        }

    }
}

extension SettingViewController: SetupWithSwichTableViewCellDelegate {

    func setupWithSwitchTableViewCell(cell: UITableViewCell, change value: Bool) {
        if let indexPath = tableView.indexPathForCell(cell) {
            if indexPath.section == 0 {
                SetupValueManager.shareInstance.isPlayInWifiOnly = value
                SetupValueManager.shareInstance.saveInfo()
            }
            else if indexPath.section == 1 {
                SetupValueManager.shareInstance.isPlayWhenOpen = value
                SetupValueManager.shareInstance.saveInfo()
            }
        }
    }

}


extension SettingViewController {

    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}

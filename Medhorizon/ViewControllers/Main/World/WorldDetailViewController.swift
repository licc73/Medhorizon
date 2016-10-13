//
//  WorldDetailViewController.swift
//  Medhorizon
//
//  Created by lichangchun on 10/13/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit

class WorldDetailViewController: UIViewController {
    let placeHolderImage = UIImage(named: "")
    
    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var labJob: UILabel!
    @IBOutlet weak var labContent: UILabel!
    @IBOutlet weak var labName: UILabel!

    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnDocument: UIButton!
    @IBOutlet weak var btnExcelentCase: UIButton!

    var expertBrief: ExpertListViewModel?

    var type: CoursewareType = .Video

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDisplayView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setDisplayView() {
        if let expert = expertBrief {
            self.labJob.text = expert.jobName
            self.labContent.text = expert.keyWordInfo
            self.labName.text = expert.zName

            if let pic = expert.picUrl, picUrl = NSURL(string: pic) {
                self.imgvThumbnail.sd_setImageWithURL(picUrl, placeholderImage: placeHolderImage)
            }
        }

        self.setTypeView()
    }

    func setTypeView() {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WorldDetailViewController {
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func chooseType(sender: UIButton) {
        if sender == self.btnVideo {
            self.type = .Video
        }
        else if sender == self.btnDocument {
            self.type = .Document
        }
        else if sender == self.btnExcelentCase {
            self.type = .ExcelentCase
        }
        self.setTypeView()
    }

}

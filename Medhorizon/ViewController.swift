//
//  ViewController.swift
//  Medhorizon
//
//  Created by changchun li on 9/30/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // change for git test 
        SignalProducer<Bool, NSError>{ observer, _ in
            observer.sendNext(true)
            observer.sendCompleted()
        }
        .on { (b) in
            print(b)
        }
        .start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


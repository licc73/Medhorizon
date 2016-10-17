//
//  NMIssueRefreshHeader.swift
//  Neumann
//
//  Created by Jason.zhang on 12/23/15.
//  Copyright © 2015 Autodesk. All rights reserved.
//

import UIKit

class NMIssueRefreshHeader: MJRefreshHeader {
    
   private lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.hidesWhenStopped = false
        self.addSubview(indicator)
        return indicator
    
    }()
    
    dynamic var isHeaderRefreshing: Bool = false
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .Idle:
                self.isHeaderRefreshing = false
                self.indicatorView.stopAnimating()
            case .Pulling:
                self.indicatorView.startAnimating()
            case .Refreshing:
                self.isHeaderRefreshing = true
                self.indicatorView.startAnimating()
            default:
                break
            }
        }
    
  
    }
    
    override func prepare() {
        super.prepare()
        self.backgroundColor = UIColor.clearColor()

    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.indicatorView.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5)
    }
  
}

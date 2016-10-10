//
//  CoverFlow.swift
//  Medhorizon
//
//  Created by lich on 10/10/16.
//  Copyright © 2016 changchun. All rights reserved.
//

import Foundation

protocol CoverFlowViewDelegate: class {
    func coverFlowView(view: CoverFlowView, didSelect index:Int)
    func numberOfCoversInCoverFlowView(view: CoverFlowView) -> Int
    func coverImage(view: CoverFlowView, atIndex index: Int) -> String?
}

let coverFlowCellIdentifier = "coverFlowCellIdentifier"

class CoverFlowView: UIView {
    let collectionView: UICollectionView
    let pageCtrl: UIPageControl
    let flowLayout: UICollectionViewFlowLayout
    var iTotalCount: Int = 0
    var iCurrentPage: Int = 0

    weak var delegate: CoverFlowViewDelegate?

    var autoScrollTimer: NSTimer?
    
    override init(frame: CGRect) {
        self.flowLayout = UICollectionViewFlowLayout()
        self.flowLayout.itemSize = frame.size
        self.flowLayout.minimumLineSpacing = 0
        self.flowLayout.minimumInteritemSpacing = 0
        self.flowLayout.scrollDirection = .Horizontal
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), collectionViewLayout: self.flowLayout)
        self.pageCtrl = UIPageControl(frame: CGRectMake(0, frame.size.height - 40, frame.size.width, 25))

        super.init(frame: frame)

        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.pagingEnabled = true
        self.addSubview(self.collectionView)
        self.addSubview(pageCtrl)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.bounces = false
        
        self.collectionView.registerNib(UINib(nibName: "CoverFlowCell", bundle: nil), forCellWithReuseIdentifier: coverFlowCellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        self.collectionView.reloadData()
        self.collectionView.contentOffset = CGPoint(x: 0, y: 0)
        self.setAutoscrollTimer()
    }

    func setAutoscrollTimer() {
        self.autoScrollTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(autoScroll(_:)), userInfo: nil, repeats: false)
    }

    func autoScroll(timer: NSTimer) {
        self.iCurrentPage = (self.iCurrentPage + 1) % self.iTotalCount
        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: self.iCurrentPage, inSection: 0), atScrollPosition: .Left, animated: true)
        self.setAutoscrollTimer()
    }
}

extension CoverFlowView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.delegate?.numberOfCoversInCoverFlowView(self) ?? 0
        self.pageCtrl.numberOfPages = count
        self.iTotalCount = count

        return count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(coverFlowCellIdentifier, forIndexPath: indexPath) as! CoverFlowCell
        cell.image = self.delegate?.coverImage(self, atIndex: indexPath.item)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.coverFlowView(self, didSelect: indexPath.item)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let ptOffset = scrollView.contentOffset
        self.iCurrentPage = Int((ptOffset.x + CGRectGetWidth(scrollView.bounds) / 2) / CGRectGetWidth(scrollView.bounds))
        self.pageCtrl.currentPage = self.iCurrentPage
    }

}

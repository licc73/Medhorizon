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
    func coverImage(view: CoverFlowView, atIndex index: Int) -> String
}

let coverFlowCellIdentifier = "coverFlowCellIdentifier"
class CoverFlowView: UIView {
    let collectionView: UICollectionView
    let pageCtrl: UIPageControl
    let flowLayout: UICollectionViewFlowLayout
    
    weak var delegate: CoverFlowViewDelegate?
    
    override init(frame: CGRect) {
        self.flowLayout = UICollectionViewFlowLayout()
        self.flowLayout.itemSize = frame.size
        self.flowLayout.minimumLineSpacing = 0
        self.flowLayout.minimumInteritemSpacing = 0
        self.flowLayout.scrollDirection = .Horizontal
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height), collectionViewLayout: self.flowLayout)
        self.pageCtrl = UIPageControl(frame: CGRectMake(0, frame.size.height - 50, frame.size.width, 25))
        super.init(frame: frame)
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(self.collectionView)
        self.addSubview(pageCtrl)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.registerNib(UINib(nibName: "CoverFlowCell", bundle: nil), forCellWithReuseIdentifier: coverFlowCellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension CoverFlowView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate?.numberOfCoversInCoverFlowView(self) ?? 0
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
    
}

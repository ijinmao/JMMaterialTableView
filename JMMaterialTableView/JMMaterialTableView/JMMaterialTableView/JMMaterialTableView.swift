//
//  JMMaterialTableView.swift
//  JMMaterialTableView
//
//  Created by dingnan on 15/10/20.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

import Foundation
import UIKit

class JMMaterialTableView: UICollectionView, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, JMMaterialLayoutDelegate {
    // ------ configurable params
    
    var shadowOffset: CGFloat = -3.0
    var shadowRadius: CGFloat = 2.0
    var shadowOpacity: Float = 0.15
    var shadowColor: CGColorRef = UIColor.darkGrayColor().CGColor
    var transformCoef: CGFloat = 0.03 {
        didSet {
            materialLayout?.kAttributesTransform = transformCoef
        }
    }
    var isTransformEnabled: Bool = true {
        didSet {
            materialLayout?.isTransformEnabled = isTransformEnabled
        }
    }
    var enableAutoScroll: Bool = true
    var enableCellShadow: Bool = true
    var scrollDecelerationRate: CGFloat = 0.3
    var shadowAnimationDuration: CFTimeInterval = 0.3
    
    var cellSize: CGSize = CGSize.zero
    
    var materialLayout: JMMaterialLayout!
    
    //--------
    
    private var cellMinSpacing: CGFloat = 0
    
    private var isScrollEndDecelerating: Bool = true
    
    private var lastScrollViewOffsetY: CGFloat = 0
    
    private var scrollWillEndOffsetY: CGFloat = 0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.decelerationRate = scrollDecelerationRate
        materialLayout = layout as! JMMaterialLayout
        materialLayout?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMinSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    // MARK: JMMaterialLayoutDelegate
    func updateItemsAttributes(allItemsAttributes: [UICollectionViewLayoutAttributes]?) {
        if !enableCellShadow {
            return
        }
        //the index of the first cell of not transformed
        var notTransformCellIndexPath: NSIndexPath? = nil
        //get indexs of shadowed cell and normal cells
        var shadowIndexPaths = [NSIndexPath]()
        var normalIndexPaths = [NSIndexPath]()
        var lastItemAttributes: UICollectionViewLayoutAttributes? = nil
        if let allItems = allItemsAttributes {
            for attributes in allItems {
                let indexPath = attributes.indexPath
                if indexPath.row > 0 {
                    if lastItemAttributes == nil {
                        shadowIndexPaths.append(attributes.indexPath)
                    }else if let lastItemAttr = lastItemAttributes {
                        if lastItemAttr.frame.origin.y + lastItemAttr.frame.size.height > attributes.frame.origin.y {
                            shadowIndexPaths.append(attributes.indexPath)
                        } else {
                            normalIndexPaths.append(attributes.indexPath)
                        }
                    }
                } else {
                    normalIndexPaths.append(attributes.indexPath)
                }
                lastItemAttributes = attributes
                //query the first cell of not transformed
                if attributes.frame.origin.x == 0 && notTransformCellIndexPath == nil {
                    notTransformCellIndexPath = attributes.indexPath
                }
            }
            //hide the cells before the first cell of not transformed
            if notTransformCellIndexPath != nil {
                if let firstAttributs = allItemsAttributes?.first {
                    for var i=firstAttributs.indexPath.row; i<notTransformCellIndexPath!.row-1; i++ {
                        let indexPath = NSIndexPath(forItem: i, inSection: 0)
                        if let cell = self.cellForItemAtIndexPath(indexPath) {
                            cell.hidden = true
                        }
                    }
                }
            }
            
            //add shadow to the cells
            if isScrollEndDecelerating {
                for indexPath in shadowIndexPaths {
                    //pass the cells not displayed in the screen
                    if notTransformCellIndexPath != nil {
                        if indexPath.row < notTransformCellIndexPath!.row-1 {
                            continue
                        }
                    }
                    if let cell = self.cellForItemAtIndexPath(indexPath) {
                        cell.hidden = false
                        //默认radius == 3.0
                        if cell.layer.shadowOpacity == 0.0 {
                            cell.layer.shadowColor = shadowColor
                            cell.layer.shadowRadius = shadowRadius
                            cell.layer.shadowOffset = CGSizeMake(0, shadowOffset)
                            animationShadowOpacity(0, to: shadowOpacity, duration: shadowAnimationDuration, cell: cell)
                        }
                    }
                }
            }
            //remove shadow of normal cells
            for indexPath in normalIndexPaths {
                //confirm whether the cells already hidden
                if notTransformCellIndexPath != nil {
                    if indexPath.row < notTransformCellIndexPath!.row-1 {
                        continue
                    }
                }
                if let cell = self.cellForItemAtIndexPath(indexPath) {
                    cell.hidden = false
                    if notTransformCellIndexPath != nil {
                        if indexPath.row == notTransformCellIndexPath!.row+1 && indexPath.row > 0 {
                            if cell.layer.shadowOpacity != 0.0 {
                                animationShadowOpacity(shadowOpacity, to: 0, duration: shadowAnimationDuration, cell: cell)
                            }
                        } else {
                            cell.layer.shadowOpacity = 0.0
                        }
                    } else {
                        cell.layer.shadowOpacity = 0.0
                    }
                }
            }
        }
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if enableCellShadow {
            if !isScrollEndDecelerating {
                //when collectionView is going to top, hide all shadow of cell
                if let allItems = materialLayout.layoutAttributesForElementsInRect(CGRectMake(0, 0
                    , self.frame.size.width, self.frame.size.height*2)) {
                        for attributes in allItems {
                            let indexPath = attributes.indexPath
                            if let cell = self.cellForItemAtIndexPath(indexPath) {
                                if cell.layer.shadowOpacity > 0 {
                                    animationShadowOpacity(shadowOpacity, to: 0, duration: shadowAnimationDuration, cell: cell)
                                }
                            }
                        }
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !enableCellShadow {
            return
        }
        print("scrollViewDidEndDragging")
        //when tableView is about going to top, hide the shadow gradually
        if self.contentOffset.y < 0 {
            isScrollEndDecelerating = false
            if let allItems = materialLayout.layoutAttributesForElementsInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*2)) {
                for attributes in allItems {
                    let indexPath = attributes.indexPath
                    if let cell = self.cellForItemAtIndexPath(indexPath) {
                        animationShadowOpacity(shadowOpacity, to: 0, duration: shadowAnimationDuration, cell: cell)
                    }
                }
            }
        }
        
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("scrollViewWillEndDragging at %f", targetContentOffset.move().y)
        scrollWillEndOffsetY = targetContentOffset.move().y
        lastScrollViewOffsetY = scrollView.contentOffset.y
        if enableAutoScroll {
            //auto scroll when end offset is in the middle of a cell
            if abs(scrollView.contentOffset.y - scrollWillEndOffsetY) <= cellSize.height {
                if scrollWillEndOffsetY > 0 {
                    let topCellIndexPath = NSIndexPath(forItem: Int(scrollWillEndOffsetY / cellSize.height) + 1, inSection: 0)
                    self.setContentOffset(CGPointMake(0, CGFloat(topCellIndexPath.row)*self.cellSize.height), animated: true)
                    self.showsVerticalScrollIndicator = false
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.showsVerticalScrollIndicator = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        isScrollEndDecelerating = true
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating")
        if enableAutoScroll {
            //dicide the srolling orientation
            if scrollWillEndOffsetY < lastScrollViewOffsetY {
                //scrolling up
                if scrollWillEndOffsetY > 0 {
                    let topCellIndexPath = NSIndexPath(forItem: Int(scrollWillEndOffsetY / cellSize.height), inSection: 0)
                    self.setContentOffset(CGPointMake(0, CGFloat(topCellIndexPath.row)*cellSize.height), animated: true)
                    self.showsVerticalScrollIndicator = false
                }
            } else if scrollWillEndOffsetY > lastScrollViewOffsetY && scrollWillEndOffsetY != 0 {
                //scrolling down
                let top2CellIndexPath = NSIndexPath(forItem: Int(abs(scrollWillEndOffsetY) / cellSize.height + 1.0), inSection: 0)
                self.setContentOffset(CGPointMake(0, CGFloat(top2CellIndexPath.row)*cellSize.height), animated: true)
                self.showsVerticalScrollIndicator = false
            }
        }
        
    }
    
    //generate shadow
    func animationShadowOpacity(from: Float, to: Float, duration: CFTimeInterval, cell: UICollectionViewCell) {
        cell.layer.shadowOpacity = to; // Note: You need the final value here
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        cell.layer.addAnimation(animation, forKey: "shadowOpacity")
    }
    
    
}
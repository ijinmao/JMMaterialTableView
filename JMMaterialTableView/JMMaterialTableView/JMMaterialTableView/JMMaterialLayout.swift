//
//  JMMaterialLayout.swift
//  JMMaterialTableView
//
//  Created by dingnan on 15/10/20.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

import Foundation
import UIKit

protocol JMMaterialLayoutDelegate {
    func updateItemsAttributes(allItemsAttributes: [UICollectionViewLayoutAttributes]?)
}

class JMMaterialLayout: UICollectionViewFlowLayout {
    
    var isTransformEnabled: Bool = true
    
    var kAttributesTransform: CGFloat = 0.03
    
    var delegate: JMMaterialLayoutDelegate?
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let allItems = super.layoutAttributesForElementsInRect(rect) {
            var headerAttributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes()
            var currentAttributes: UICollectionViewLayoutAttributes? = nil
            var lastAttributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes()
            for attributes: UICollectionViewLayoutAttributes in allItems {
                let indexPath = attributes.indexPath
                if attributes.representedElementKind == UICollectionElementKindSectionHeader {
                    headerAttributes = attributes
                } else {
                    if let firstItemAttributes = currentAttributes {
                        if indexPath.row > firstItemAttributes.indexPath.row && collectionView!.contentOffset.y >= 0 {
                            currentAttributes = attributes
                            updateItemAttributes(firstItemAttributes, headerAttributes: headerAttributes)
                        }
                    }else {
                        currentAttributes = attributes
                    }
                    if indexPath.row > 0 && collectionView!.contentOffset.y < 0 {
                        currentAttributes = attributes
                        updateItemAttributesAtTopPosition(currentAttributes!, lastAttributes: lastAttributes, lastItemIndex: allItems.last!.indexPath.row)
                    }
                    lastAttributes = attributes
                }
            }
            delegate?.updateItemsAttributes(allItems)
            return allItems
        }
        return []
    }
    
    //transform top items attributes
    private func updateItemAttributes(attributes: UICollectionViewLayoutAttributes, headerAttributes: UICollectionViewLayoutAttributes) {
        let itemOriginalFrame = attributes.frame
        let itemMaxY: CGFloat = CGRectGetMaxY(attributes.frame) - CGRectGetHeight(headerAttributes.bounds)
        let itemMinY: CGFloat = (self.collectionView?.contentOffset.y)! + (self.collectionView?.contentInset.top)!
        let largerYPosition: CGFloat = max(itemMinY, attributes.frame.origin.y)
        let finalPosition: CGFloat = min(itemMaxY, largerYPosition)
        var itemOrigin = attributes.frame.origin
        let deltaY: CGFloat = (finalPosition - itemOrigin.y) / CGRectGetHeight(attributes.frame)
        itemOrigin.y = finalPosition

        let transformCoef: CGFloat = (1 - deltaY * kAttributesTransform)
        if isTransformEnabled {
            attributes.transform = CGAffineTransformMakeScale(transformCoef, transformCoef)
            attributes.frame = CGRectMake(itemOriginalFrame.origin.x, itemOrigin.y, itemOriginalFrame.size.width, itemOriginalFrame.size.height)
        }
        attributes.zIndex = attributes.indexPath.row;
        
    }
    
    //transform items when collectionView did scroll to top
    private func updateItemAttributesAtTopPosition(attributes: UICollectionViewLayoutAttributes, lastAttributes: UICollectionViewLayoutAttributes, lastItemIndex: Int) {
        var collectionViewDeltaY = abs((collectionView?.contentOffset.y)! / collectionView!.frame.size.height)
        //along y axis, reduce the cover area
        let coef: CGFloat = 0.08
        collectionViewDeltaY = collectionViewDeltaY - CGFloat(attributes.indexPath.row) * coef * collectionViewDeltaY
        let itemOriginY = lastAttributes.frame.origin.y + lastAttributes.frame.size.height * (1 - collectionViewDeltaY)
        attributes.frame = CGRectMake(attributes.frame.origin.x, itemOriginY, attributes.frame.size.width, attributes.frame.size.height)
        attributes.zIndex = attributes.indexPath.row
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
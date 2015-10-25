//
//  TableViewDataSource.swift
//  JMMaterialTableViewDemo
//
//  Created by dingnan on 15/10/24.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSource: NSObject, UICollectionViewDataSource {
    
    private var cellReuseIdentifier: String
    private var collectionView: JMMaterialTableView
    
    //cell的dataSource
    private let cellTitles = [
        "ijinmao", "iOS", "Meiqia", "UX",
        "ijinmao", "iOS", "Meiqia", "UX",
        "ijinmao", "iOS", "Meiqia", "UX",
        "ijinmao", "iOS", "Meiqia", "UX",
        "ijinmao", "iOS", "Meiqia", "UX"
    ]
    
    private let cellColors = [
        UIColor(red: 82.0/255.0,  green: 188.0/255.0, blue: 206.0/255.0, alpha: 1.0),
        UIColor(red: 78.0/255.0,  green: 173.0/255.0, blue: 164.0/255.0, alpha: 1.0),
        UIColor(red: 125.0/255.0, green: 189.0/255.0, blue: 127.0/255.0, alpha: 1.0),
        UIColor(red: 169.0/255.0, green: 205.0/255.0, blue: 127.0/255.0, alpha: 1.0)
    ]
    
    var cellHeight: CGFloat = 0
    
    init(collectionView: JMMaterialTableView, cellReuseIdentifier: String) {
        self.collectionView = collectionView
        self.cellReuseIdentifier = cellReuseIdentifier
        self.collectionView.cellSize = CGSizeMake(collectionView.frame.size.width, 128)
        self.collectionView.registerClass(JMMaterialCell.classForCoder(), forCellWithReuseIdentifier: cellReuseIdentifier)
        super.init()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: JMMaterialCell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath) as! JMMaterialCell
        cell.detailText = cellTitles[indexPath.row % cellTitles.count]
        cell.cellColor = cellColors[indexPath.row % cellColors.count]
        return cell
    }
    
}
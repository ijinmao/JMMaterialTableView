//
//  JMMaterialCell.swift
//  JMMaterialTableViewDemo
//
//  Created by dingnan on 15/10/24.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

import Foundation
import UIKit

class JMMaterialCell: UICollectionViewCell {
    
    var cellColor: UIColor? {
        didSet {
            self.backgroundColor = cellColor
        }
    }
    
    var detailText: String? {
        didSet {
           self.detailLabel?.text = detailText
        }
    }
    
    private var detailLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.detailLabel = UILabel(frame: CGRectMake(0, 0, frame.size.width, frame.size.height-1))
        self.detailLabel?.textColor = UIColor.whiteColor()
        self.detailLabel?.font = UIFont(name: "Copperplate-Bold", size: 19.0)
        self.detailLabel?.textAlignment = NSTextAlignment.Center
        self.addSubview(self.detailLabel!)
    }
    
}
//
//  ViewController.swift
//  JMMaterialTableView
//
//  Created by dingnan on 15/10/25.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView: JMMaterialTableView!
    private var tableViewDataSource: TableViewDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false

        let navBarFrame = self.navigationController?.navigationBar.frame
        let navBarColor = UIColor(red: 80.0/255.0, green: 108.0/255.0, blue: 119.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = navBarColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let layout = JMMaterialLayout()
        tableView = JMMaterialTableView(frame: CGRectMake(0, navBarFrame!.origin.y + navBarFrame!.size.height, navBarFrame!.size.width, view.frame.size.height - navBarFrame!.size.height), collectionViewLayout: layout)
        tableView.backgroundColor = navBarColor
        tableViewDataSource = TableViewDataSource(collectionView: tableView, cellReuseIdentifier: "cell")
        tableView.dataSource = tableViewDataSource
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


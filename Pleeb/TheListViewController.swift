//
//  TheListViewController.swift
//  Pleeb
//
//  Created by Brent Kirkland on 3/23/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation

class TheListiewController: ExampleViewController, UITableViewDelegate, UITableViewDataSource {

    let babe = ["brentkirkland", "liamsdouble", "sirfrancesbreen", "spencerwross", "taybae08", "losermcagee", "skrillex"]
    
    var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.restorationIdentifier = "TheListiewController"
    }
    
    override init() {
        super.init()
        
        self.restorationIdentifier = "TheListiewController"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("Left will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("Left did appear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("Left will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("Left did disappear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "the List"
        let font = UIFont(name: "HelveticaNeue-Light", size: 22)
        if let font = font {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)]
            //self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(4.5, forBarMetrics: .Default)
        }

        self.tableView = UITableView(frame: self.view.bounds, style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return babe.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "TagCell"
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellID)
        }
        
        cell.textLabel?.text = babe[indexPath.row]
        cell.detailTextLabel?.text = "ERR BODY"
        
        return cell
        
    }
    
    
    //delegate
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        
//    }
//    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        
//    }
    
}
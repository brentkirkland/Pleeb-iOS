//
//  TagSelectorViewController.swift
//  Livv
//
//  Created by Brent Kirkland on 3/21/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit

class TagSelectorViewController: ExampleViewController, UITableViewDelegate, UITableViewDataSource {
   
    let babe = ["DeepHouse", "Dayger", "Weed", "ShittyFood", "ChineseSunrise", "Beer", "HaveFun!"]
    var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.restorationIdentifier = "TagSelectorViewController"
    }
    
    override init() {
        super.init()
        
        self.restorationIdentifier = "TagSelectorViewController"
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
        
        self.title = "Leader Board"
        let font = UIFont(name: "HelveticaNeue-Light", size: 22)
        if let font = font {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.whiteColor()]
            //self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(4.5, forBarMetrics: .Default)
        }
        let barColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        self.view.backgroundColor = barColor
        self.navigationController?.navigationBar.backgroundColor = barColor
        self.navigationController?.navigationBar.barTintColor = barColor
        
        
        self.tableView = UITableView(frame: self.view.bounds, style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        self.tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.tableView.separatorStyle = .None
        self.tableView.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        self.tableView.estimatedRowHeight = 40
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    //table data source
//    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
//        return 1
//    }
//    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "TagCell"
        var cell:TagButtonTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? TagButtonTableViewCell
        
        if (cell == nil) {
            
            cell = TagButtonTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID)
            
        }
        
        var x: CGFloat = 22.0
        
        if indexPath.row < 3 {
            
            x = 28.0
        }
        
        //cell.tagName.text = babe[indexPath.row] as String!
        //cell.fitToSize(x, )
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
//        println(cell.frame)
//        
//        cell.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
//        cell.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
//        cell.textLabel?.text = "hey"
//        cell.textLabel?.textColor = UIColor.whiteColor()
//        //cell.textLabel?.highlighted = true
//        //cell.textLabel?.highlightedTextColor = UIColor.whiteColor()
//        cell.textLabel?.backgroundColor = UIColor.blackColor()
//        
        return cell
    }
    
    //delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell: TagButtonTableViewCell! = tableView.cellForRowAtIndexPath(indexPath) as? TagButtonTableViewCell
        
        println(cell.frame)
       // println(cell.background.frame)
        

        //cell.background.backgroundColor = UIColor.blueColor()
        
        
        println("You selected cell #\(indexPath.row)!")
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row > 2 {
            return (CGFloat(indexPath.row))*31.5
        }
        return (CGFloat(indexPath.row))*44.0
    }
}

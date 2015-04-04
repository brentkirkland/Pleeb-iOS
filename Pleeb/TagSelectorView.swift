//
//  TagSelectorView.swift
//  Pleeb
//
//  Created by Brent Kirkland on 4/3/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation

class TagSelectorView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var addTag: UITextField!
    var addTagBackground: UIView!
    var done: UIButton!
    
    var tableView: UITableView!
    
    var tags: [String] = ["Deltopia", "Sadaf Sucks", "Your Momma", "DP", "Random", "Slyd", "Devin Toner","Deltopia", "Sadaf Sucks", "Your Momma", "DP"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    deinit{
        
        
    }
    
    func commonSetup(){
        
        
        addTagBackground = UIView()
        addTagBackground.backgroundColor = UIColor(red: 41/255, green: 171/255, blue: 226/255, alpha: 0.9)
        addTagBackground.layer.cornerRadius = 2
        self.addSubview(addTagBackground)
        
        //addTag button
        addTag = UITextField(frame: CGRect(x: 7, y: 2, width: 90, height: 20))
        addTag.attributedPlaceholder = NSAttributedString(string:"Add Tag",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        addTag.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        addTag.textColor = UIColor.whiteColor()
        fitToSize()
        addTag.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
        addTag.returnKeyType = UIReturnKeyType.Done
        addTag.delegate = self
        addTag.layer.cornerRadius = 2
        
    
        addTagBackground.addSubview(addTag)
        
        done = UIButton()
        done.setTitle("Cancel", forState: UIControlState.Normal)
        done.setTitle("Submit", forState: UIControlState.Highlighted)
        done.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        done.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        done.addTarget(self, action: "submit:", forControlEvents: .TouchUpInside)
        //done.layer.cornerRadius = 2
        //done.sizeToFit()
        done.frame = CGRect(x: 0, y: self.frame.height - 50, width: self.frame.width, height: 50)
        self.addSubview(done)
        
        //addTags()
        
        tableView = UITableView(frame: CGRectMake(0, 31, self.frame.size.width, self.frame.size.height-31-50))
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.rowHeight = 38
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        self.addSubview(tableView)
//        
//        var singletap: UITapGestureRecognizer  = UITapGestureRecognizer(target: self, action: "singleTap:")
//        singletap.numberOfTapsRequired = 1
//        self.addGestureRecognizer(singletap)
    }
    
    func submit(selector: UIButton!){
        selector.highlighted = false
        self.removeFromSuperview()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("tags count is: \(tags.count)")
        return tags.count
    }
//
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = tags[indexPath.row]
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? UITableViewCell
        
        if (cell == nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID)
            
        
        cell.backgroundColor = UIColor.clearColor()
        var button: UIButton! = UIButton()
        button.addTarget(self, action: "selectedTag:", forControlEvents: .TouchUpInside)
        button.setTitle(tags[indexPath.row], forState: .Normal)
        
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        button?.sizeToFit()
        button.layer.cornerRadius = 2
        
        var titleWidth: CGFloat! = (button.titleLabel?.frame.width as CGFloat!) + 10
        var titleHeight: CGFloat! = (button.titleLabel?.frame.size.height as CGFloat!) + 5
        
        button.frame = CGRect(x: 10, y: 10, width: titleWidth, height: titleHeight)
        
        cell.contentView.addSubview(button)
        cell.selectionStyle = .None
        cell.backgroundView = nil
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        }
        
        return cell
    }
//
    func selectedTag(sender: UIButton!){
        
        done.highlighted = true
        
        if sender.backgroundColor != UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0){
            
            sender.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        } else {
            
            sender.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            sender.setTitleColor(UIColor.blackColor(), forState: .Normal)
            
        }
    }
    
    
    func fitToSize(){
        
        //used when typing
        addTag?.sizeToFit()
        addTagBackground.frame = CGRect(x: 10, y: 0, width: addTag.frame.size.width + 10, height:  addTag.frame.size.height + 5)
        println("size of addTag is\(addTagBackground.frame)")
        
    }
    
    func textFieldChanged(sender: UITextField!) {
        
        fitToSize()
        
    }
    
//    func addTags(){
//        
//        for var i = 0; i < tags.count; i++ {
//            
//            var button = makeTagButton(tags[i])
//            self.addSubview(button)
//        }
//        
//    }
    
//    func makeTagButton(string: String) -> UIButton{
//        //var xpos:Int! = (z)
//        
//        var button: UIButton! = UIButton()
//        button.setTitle(string, forState: .Normal)
//        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
//        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
//        button.layer.cornerRadius = 2
//        button.sizeToFit()
//        var width:CGFloat = button.frame.width + 15
//        var x:CGFloat! = 10
//        var y:CGFloat! = 10*line + 31*(line)
//        var height:CGFloat! = 31
//        
//        self.line = self.line + 1
//        
//        button.frame = CGRectMake(x, y, width, height)
//        //button.frame = CGRect(x: xpos + 10, y: 0, width: wide + 15, height: 31)
//        
//        
//        return button
//        
//    }
    
    
    
}
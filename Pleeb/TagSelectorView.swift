//
//  TagSelectorView.swift
//  Pleeb
//
//  Created by Brent Kirkland on 4/3/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation

struct Tags {
    var title: String!
    var isPrivate: Bool!
    var isContact: Bool!
    var phone: String!
}

class TagSelectorView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var addTag: UITextField!
    var addTagBackground: UIView!
    var done: UIButton!
    
    var tableView: UITableView!
    
    var searchedTags: [Tags] = []
    var tags: [Tags] = []
    var selectedTags: [Tags] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    deinit{
        addTag = nil
        addTagBackground = nil
        done = nil
        tableView = nil
        searchedTags = []
        tags = []
        selectedTags = []
    }
    
    func commonSetup(){
        
        addTagBackground = UIView()
        addTagBackground.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9)
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
        addTag.keyboardType = .Twitter
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
        
    }
    
    func submit(selector: UIButton!){
        selector.highlighted = false
        self.removeFromSuperview()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("tags count is: \(tags.count)")
        println("searchedTags count is: \(searchedTags.count)")
        return tags.count + searchedTags.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        //searchedtags / addedtags
        if searchedTags.count > indexPath.row {
            
            //if it's a contact -> yellow dude
            if searchedTags[indexPath.row].isContact == true && searchedTags[indexPath.row].isPrivate == false {
                
                let cellID = searchedTags[indexPath.row].title
                var cell:ContactButtonTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? ContactButtonTableViewCell
                
                if (cell == nil) {
                    
                    cell = ContactButtonTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: searchedTags[indexPath.row])
                    
                    cell.backgroundColor = UIColor.clearColor()
                    
                    cell.selectionStyle = .None
                    cell.backgroundView = nil
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    
                }
                
                return cell
            }
            
            //if it's a private tag -> pink dude
            else if searchedTags[indexPath.row].isContact == false && searchedTags[indexPath.row].isPrivate == true {
                
                let cellID = searchedTags[indexPath.row].title
                var cell:PrivateButtonTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? PrivateButtonTableViewCell
                
                if (cell == nil) {
                    
                    cell = PrivateButtonTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: searchedTags[indexPath.row])
                    
                    cell.backgroundColor = UIColor.clearColor()
                    
                    cell.selectionStyle = .None
                    cell.backgroundView = nil
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    
                }
                
                return cell
                
            }
            // if it's a normal tag -> cyan dude
            else{
                
                println("cyan dude")
                
                let cellID = searchedTags[indexPath.row].title
                var cell:TagButtonViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? TagButtonViewCell
                
                if (cell == nil) {
                    
                    cell = TagButtonViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: searchedTags[indexPath.row])
                    
                    cell.backgroundColor = UIColor.clearColor()
                    
                    cell.selectionStyle = .None
                    cell.backgroundView = nil
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    
                }
                
                return cell
                
            }
            
        // when a tag has been added and unadded it goes here
        } else {
            
            //if it's a contact -> yellow dude
            if tags[indexPath.row - searchedTags.count].isContact == true && tags[indexPath.row - searchedTags.count].isPrivate == false {
                
                let cellID = tags[indexPath.row - searchedTags.count].title
                var cell:ContactButtonTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? ContactButtonTableViewCell
                
                if (cell == nil) {
                    
                    cell = ContactButtonTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: tags[indexPath.row - searchedTags.count])
                    
                    cell.backgroundColor = UIColor.clearColor()
                    
                    cell.selectionStyle = .None
                    cell.backgroundView = nil
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    
                }
                return cell
                
            }
                //if it's a private tag -> pink dude
            else if tags[indexPath.row - searchedTags.count].isContact == false && tags[indexPath.row - searchedTags.count].isPrivate == true {
                
                let cellID = tags[indexPath.row - searchedTags.count].title
                var cell:PrivateButtonTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? PrivateButtonTableViewCell
                
                if (cell == nil) {
                    
                    cell = PrivateButtonTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: tags[indexPath.row - searchedTags.count])
                    
                    cell.backgroundColor = UIColor.clearColor()
                    
                    cell.selectionStyle = .None
                    cell.backgroundView = nil
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    
                }
                return cell
                
            }
            else{
                
                let cellID = tags[indexPath.row - searchedTags.count].title
                var cell:TagButtonViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? TagButtonViewCell
                
                if (cell == nil) {
                    
                    cell = TagButtonViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, view: self, tag: tags[indexPath.row - searchedTags.count])
                    
                    cell.backgroundColor = UIColor.clearColor()
                    
                    cell.selectionStyle = .None
                    cell.backgroundView = nil
                    cell.contentView.backgroundColor = UIColor.clearColor()
                    
                }
                return cell
            }
        }
        
    }
    
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

        addTag?.sizeToFit()
        addTagBackground.frame = CGRect(x: 10, y: 0, width: addTag.frame.size.width + 10, height:  addTag.frame.size.height + 5)
        
    }
    
    func textFieldChanged(sender: UITextField!) {
        
        fitToSize()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var actualString: String! = ""

        println("The textfield text is: \(textField.text)")
        println("The textfield plus string is: \(textField.text + string)")
        println("The string is: \(string)")
        println(range)
        
        if string == "" {
            
            actualString = textField.text.substringWithRange(Range<String.Index>(start: textField.text.startIndex, end: advance(textField.text.endIndex, -1)))
            
        } else {
            
            actualString = textField.text + string
        }
        
        println("actual string \(actualString)")
        
        if (actualString).utf16Count > 1{
            
            if (actualString as NSString).substringToIndex(1) == "@" {
                
                var newString = (actualString as NSString).substringFromIndex(1)
                
                if Contacts.objectsWhere("name CONTAINS[c] '\(newString)'").count > 0 {
                    
                    self.searchedTags = []
                    
                    var length: UInt = Contacts.objectsWhere("name CONTAINS[c] '\(newString)' AND phone BEGINSWITH '1'").count
                    //println(length)
                    var cntcts = Contacts.objectsWhere("name CONTAINS[c] '\(newString)' AND phone BEGINSWITH '1'")
        
                    
                    for var i: UInt = 0; i < length; i++ {
                        
                        println((cntcts[i] as Contacts).phone)
                        
                        var tag = Tags(title: (cntcts[i] as Contacts).name, isPrivate: false, isContact: true, phone: (cntcts[i] as Contacts).phone)
                        
                        searchedTags.append(tag)
                        
                    }
                    
                    self.tableView.reloadData()
                }

            }
            else if (actualString as NSString).substringToIndex(1) == "#" {
                
                var newString = (actualString as NSString).substringFromIndex(1)
                
                if searchedTags.count > 0 {
                    
                    self.searchedTags[0].title = newString
                    
                } else {
                    
                    self.searchedTags.append(Tags(title: newString, isPrivate: true, isContact: false, phone: ""))
                }
                
                self.tableView.reloadData()

                
            }
            else {
                
                if searchedTags.count > 0 {
                    
                    self.searchedTags[0].title = actualString
                    
                } else {
                    
                    self.searchedTags.append(Tags(title: actualString, isPrivate: false, isContact: false, phone: ""))
                }
                
                self.tableView.reloadData()
                
            }
        }

        else {
            
            self.searchedTags = []
            self.tableView.reloadData()
            
        }
        
        return true
    }
    
    
    
}
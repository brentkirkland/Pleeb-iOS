//
//  TagButtonViewCell.swift
//  Pleeb
//
//  Created by Brent Kirkland on 4/4/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation

class TagButtonViewCell: UITableViewCell {
    
    var view: TagSelectorView!
    
    var title: String!
    var button: UIButton! = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.commonSetup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    init(style: UITableViewCellStyle, reuseIdentifier: String?, view: TagSelectorView, title: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.view = view
        self.title = title
        button.setTitle(title, forState: .Normal)
        self.commonSetup()
        button.addTarget(self, action: "selectedTag:", forControlEvents: .TouchUpInside)
    }
    deinit {
        
        view = nil
        
    }
    
    func commonSetup(){
        
        button.setTitleColor(UIColor(red: 50/255, green: 255/255, blue: 255/255, alpha: 1.0), forState: .Normal)
        //button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        button.sizeToFit()
        button.layer.cornerRadius = 2
        var titleWidth: CGFloat! = (button.titleLabel?.frame.width as CGFloat!) + 10
        var titleHeight: CGFloat! = (button.titleLabel?.frame.size.height as CGFloat!) + 5
        button.frame = CGRect(x: 10, y: 10, width: titleWidth, height: titleHeight)
        contentView.addSubview(button)
        
    }
    
    func selectedTag(sender: UIButton!){
        
        if button.backgroundColor == UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9) {
        
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.backgroundColor = UIColor(red: 50/255, green: 255/255, blue: 255/255, alpha: 0.9)
//            self.view.selectedTags.append(Tags(title: title, isContact: false, phone: ""))
//            self.view.tags.insert(Tags(title: title, isContact: false, phone: ""), atIndex: 0)
//            println(view.tags[0].title)
//            println(view.tags.count)
//            view.addTag.text = nil
//            view.searchedTags = []
//            view.tableView.reloadData()
            
            //selected
            
            
        }else {
            
            button.setTitleColor(UIColor(red: 50/255, green: 255/255, blue: 255/255, alpha: 1.0), forState: .Normal)
            button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9)
            
            //deselected
        }
        
        println("selected Tag")
        
    }

}
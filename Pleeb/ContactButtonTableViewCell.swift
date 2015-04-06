//
//  ContactButtonTableViewCell.swift
//  Pleeb
//
//  Created by Brent Kirkland on 4/4/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation

class ContactButtonTableViewCell: TagButtonViewCell {
    
    var phone: String!
    let theTag: Tags!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    init(style: UITableViewCellStyle, reuseIdentifier: String?, view: TagSelectorView, tag: Tags) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        button.setTitle(tag.title, forState: .Normal)
        super.title = tag.title
        self.theTag = tag
        super.view = view
        self.commonSetup()
        button.addTarget(self, action: "selectedContact:", forControlEvents: .TouchUpInside)
        self.phone = tag.phone
    }
    
    override func commonSetup(){
        
        button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 50/255, alpha: 1.0), forState: .Normal)
        //button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), forState: .Highlighted)
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
    
    func selectedContact(sender: UIButton!){
        
        if button.titleLabel?.textColor == UIColor(red: 255/255, green: 255/255, blue: 50/255, alpha: 1.0) && button.backgroundColor == UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9){
            
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 50/255, alpha: 0.9)
            super.view.selectedTags.append(Tags(title: theTag.title, isContact: true, phone: theTag.phone))
            super.view.tags.insert(Tags(title: theTag.title, isContact: true, phone: theTag.phone), atIndex: 0)
            println(view.tags[0].title)
            println(view.tags.count)
            view.addTag.text = nil
            view.searchedTags = []
            view.tableView.reloadData()

            
        } else if button.backgroundColor == UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.89) {
            
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 50/255, alpha: 0.9)
            
            
            //add back to selected tags
            //change color to black

        }
        
        
        else {
            
            button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 50/255, alpha: 1.0), forState: .Normal)
            button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.89)
            
            
            //remove from selected tags
        }

        
    }

}
//
//  PrivateButtonTableViewCell.swift
//  Pleeb
//
//  Created by Brent Kirkland on 4/6/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation

class PrivateButtonTableViewCell: TagButtonViewCell {
    
    //let theTag: Tags!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?, view: TagSelectorView, tag: Tags) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        button.setTitle(tag.title, forState: .Normal)
        //super.title = tag.title
        self.theTag = tag
        super.view = view
        self.commonSetup()
        button.addTarget(self, action: "selectedPrivateTag:", forControlEvents: .TouchUpInside)
        
    }
    
    override func commonSetup(){
        
        button.setTitleColor(UIColor(red: 255/255, green: 50/255, blue: 255/255, alpha: 1.0), forState: .Normal)
        button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        button.sizeToFit()
        button.layer.cornerRadius = 2
        var titleWidth: CGFloat! = (button.titleLabel?.frame.width as CGFloat!) + 10
        var titleHeight: CGFloat! = (button.titleLabel?.frame.size.height as CGFloat!) + 5
        button.frame = CGRect(x: 10, y: 10, width: titleWidth, height: titleHeight)
        contentView.addSubview(button)
        
    }
    
    func selectedPrivateTag(sender: UIButton!){
        
        if button.backgroundColor == UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9) {
            
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.backgroundColor = UIColor(red: 255/255, green: 50/255, blue: 255/255, alpha: 0.9)

            
            //selected
            //add to tag
            // add to selected tag
            super.view.addTag.text = ""
            super.view.searchedTags = []
            super.view.addTag.sizeToFit()
            super.view.tags.insert(theTag, atIndex: 0)
            super.view.selectedTags.append(theTag)
            super.view.tableView.reloadData()
            
            
        }else {
            
            button.setTitleColor(UIColor(red: 255/255, green: 50/255, blue: 255/255, alpha: 1.0), forState: .Normal)
            button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9)
            
            //deselected
            //do not remove from tag
            //remove from selected tag
            
//            for var i: Int = 0; i < super.view.selectedTags.count; i++ {
//                
//                if super.view.selectedTags[i].title == theTag.title && super.view.selectedTags[i].isPrivate == true {
//                    
//                    super.view.selectedTags.removeAtIndex(i)
//                    
//                }
//                
//            }
            
            
            
        }
        
        
    }
    
}
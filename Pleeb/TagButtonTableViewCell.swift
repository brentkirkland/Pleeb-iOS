//
//  TagButtonTableViewCell.swift
//  Pleeb
//
//  Created by Brent Kirkland on 3/21/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit

class TagButtonTableViewCell: UITableViewCell {
    
    var mapClass: ExampleCenterTableViewController!
    var backgroundButton: UIButton! = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, mapClass: ExampleCenterTableViewController) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.mapClass = mapClass
        mySetup()
        
    }
    deinit {
        backgroundButton = nil
        mapClass = nil

    }
    
    func mySetup(){
        
        contentView.backgroundColor = UIColor.clearColor()
        contentView.addSubview(backgroundButton)
        backgroundButton.addTarget(self, action: "buttonPress:", forControlEvents: .TouchUpInside)

        selectionStyle = UITableViewCellSelectionStyle.None
        
        backgroundView = nil
        backgroundColor = UIColor.clearColor()
        
    }
    
    func fitToSize(fontSize: CGFloat) {
        
        
        if(backgroundButton.titleLabel?.text != nil){
            

            backgroundButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            backgroundButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: fontSize)
            backgroundButton?.sizeToFit()
            
            var titleWidth: CGFloat! = (backgroundButton.titleLabel?.frame.width as CGFloat!) + 10
            var titleHeight: CGFloat! = (backgroundButton.titleLabel?.frame.size.height as CGFloat!) + 5

            backgroundButton.frame = CGRect(x: 10, y: 10, width: titleWidth, height: titleHeight)
            
        }
        
        
    }
    
    func buttonPress(sender: UIButton!){
        
        backgroundButton.backgroundColor = UIColor(red: 41/255, green: 171/255, blue: 226/255, alpha: 1.0)
        
        if backgroundButton.titleLabel?.text != nil {
            mapClass.post(backgroundButton.titleLabel?.text!)
      }
        
    }

    
}

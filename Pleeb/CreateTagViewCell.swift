//
//  CreateTagViewCell.swift
//  Pleeb
//
//  Created by Brent Kirkland on 3/22/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//


import UIKit
import Alamofire

class CreateTagViewCell: UITableViewCell, UITextFieldDelegate {
    
    var newTag: UITextField! = UITextField()
    var background: UIView! = UIView()
    var mapClass: ExampleCenterTableViewController!
    
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
    deinit{
        mapClass = nil
        println("CreateTagViewCell deallocated")
    }
    
    func mySetup(){
        
        
        contentView.backgroundColor = UIColor.clearColor()
        contentView.addSubview(background)
        background.addSubview(newTag)
        
        newTag?.frame = CGRect(x: 5, y: 2, width: 90, height: 20)
        newTag.attributedPlaceholder = NSAttributedString(string:"Add Tag",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        newTag.sizeToFit()
        newTag.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
        newTag.returnKeyType = UIReturnKeyType.Done
        newTag.delegate = self
        
        selectionStyle = UITableViewCellSelectionStyle.None
        
        backgroundView = nil
        backgroundColor = UIColor.clearColor()
        
        background.backgroundColor = UIColor(red: 41/255, green: 171/255, blue: 226/255, alpha: 1.0)
        fitToSize(22)
    }
    
    func fitToSize(fontSize: CGFloat) {
            
        newTag.font = UIFont(name: "HelveticaNeue-Light", size: fontSize)
        newTag?.sizeToFit()
        newTag.textColor = UIColor.whiteColor()
            
        background.frame = CGRect(x: 10, y: 10, width: newTag.frame.size.width + 10, height:  newTag.frame.size.height + 5)
        
        
    }
    
    func textFieldChanged(sender: UITextField!){
        
        newTag.sizeToFit()
        fitToSize(22)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("check")
        mapClass.post(newTag.text)
        mapClass.tableView.endEditing(true)
        return true
        
    }

    
    
}

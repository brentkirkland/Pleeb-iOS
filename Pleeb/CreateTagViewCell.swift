//
//  CreateTagViewCell.swift
//  LIVV
//
//  Created by Brent Kirkland on 3/22/15.



import Foundation
import Alamofire

class CreateTagViewCell: UITableViewCell, UITextFieldDelegate {
    
    var newTag: UITextField! = UITextField()
    var background: UIView! = UIView()
    var mapClass: MapViewController!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    init(style: UITableViewCellStyle, reuseIdentifier: String?, mapClass: MapViewController) {
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
        newTag.keyboardType = UIKeyboardType.Twitter
        //newTag.keyboardAppearance = UIKeyboardA
        newTag.delegate = self
        
        selectionStyle = UITableViewCellSelectionStyle.None
        
        backgroundView = nil
        backgroundColor = UIColor.clearColor()
        
        background.backgroundColor = UIColor(red: 41/255, green: 171/255, blue: 226/255, alpha: 1.0)
        background.layer.cornerRadius = 2
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        println("Started editing")

    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == newTag{

            //println(textField.text)
            
            println("here inside")
            
            if textField.text.utf16Count == 2{
            
            if (textField.text as NSString).substringToIndex(1) == "@" {
                //fitToSize(22)
                println("Check mate")
                println((textField.text as NSString) + string)
                println("the range is \(range)")
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    self.mapClass.tableView.future = true
                    dispatch_async(dispatch_get_main_queue()) {
                        self.mapClass.tableView.reloadData()
                    }
                }
                
                
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let users = User.allObjects()
        var user = users[UInt(0)] as User
        
        if user.username == "" {
            
            mapClass.tableView.hidden = true
            var createView: CreateUsernameView! = CreateUsernameView(frame: CGRectMake(50, -170, mapClass.view.frame.size.width-100, 170))
            mapClass.view.addSubview(createView)
            createView.openWindow(mapClass, tag: newTag.text)
            println("here")
            return true
            
        }
        if newTag.text != "" && newTag.text != "@"{
            println("check")
            mapClass.post(newTag.text)
            mapClass.tableView.endEditing(true)
            println("heree nikka")
            return true
            
        }
        else {
            println("hereee")
            mapClass.tableView.endEditing(true)
            mapClass.tableView.closeWindow(mapClass.tableView)
            return true
        }
        
        
    }

    
    
}

//
//  SearchBarView.swift
//  Livv
//
//  Created by Brent Kirkland on 4/3/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit

class SearchBarView: UIView {
    
    var textField: UITextField!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    deinit{
        
        textField = nil
        
    }
    
    func commonSetup(){
        //view
        self.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        self.layer.cornerRadius = 2
        
        //searchbar
        textField = UITextField(frame: CGRectMake(10, 0, self.frame.width - 20, self.frame.height))
        textField.attributedPlaceholder = NSAttributedString(string:"L I V V",
            attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
        textField.textAlignment = NSTextAlignment.Left
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        textField.textColor = UIColor.blackColor()
        
//        var searchImage: UIImage! = UIImage(named: "searchIcon.png")
//        var searchImageView: UIImageView = UIImageView(image: searchImage)
//        
//        searchImageView.frame = CGRectMake(10,10,self.frame.height-20, self.frame.height-20)
        
//        self.addSubview(searchImageView)
       // UIImageView(frame: CGRectMake(0,0,self.frame.width, self.frame.height))
        
        
        self.addSubview(textField)

        
    }
    
    
}
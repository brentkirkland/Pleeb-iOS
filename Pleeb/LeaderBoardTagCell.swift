//
//  LeaderBoardTagCell.swift
//  Pleeb
//
//  Created by Brent Kirkland on 3/26/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit


class LeaderBoardTagCell: UITableViewCell {
    
    var rankLabel: UILabel! = UILabel()
    var username: String!
    var rank: String!
    var separatorLineView: UIView! = UIView()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, index: Int!, rank: Int!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp(index, rank: rank)
    }
    deinit {
        
        rankLabel = nil
        username = nil
        rank = nil
        separatorLineView = nil
        
    }
    
    func setUp(index: Int!, rank: Int!){
        
        selectionStyle = .None
        
        
        rankLabel.frame = CGRectMake(190, 8, 20, 20)
        rankLabel.font = UIFont(name: "HelveticaNeue-UltraLight",
            size: 17.0)
        rankLabel.textColor = UIColor.blackColor()
        rankLabel.textAlignment = NSTextAlignment.Right
        contentView.addSubview(rankLabel)
        
        
        if (index == 0){
            white()
        }

        else {
            
            contentView.backgroundColor  = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
            textLabel?.textColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
            textLabel?.font = UIFont(name: "HelveticaNeue",
                size: 17.0)
            
            separatorLineView.frame = CGRectMake(15, 0, contentView.frame.size.width - 15, 1)
            separatorLineView.backgroundColor  = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            contentView.addSubview(separatorLineView)
            
        }
        
        
        
    }
    
    func white(){
        
        contentView.backgroundColor = UIColor.whiteColor()
        textLabel?.font = UIFont(name: "HelveticaNeue-Medium",
            size: 17.0)
        textLabel?.textColor = UIColor.blackColor()
    }
}
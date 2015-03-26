//
//  TagSelectorTableView.swift
//  Pleeb
//
//  Created by Brent Kirkland on 3/23/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import Realm

class TagSelectorTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var event: Event!
    var length: Int! = 1

    var mapClass: ExampleCenterTableViewController!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(mapClass: ExampleCenterTableViewController)
    {
        super.init(frame: CGRect(x: -mapClass.view.frame.width, y: 62, width: mapClass.view.frame.width, height: mapClass.view.frame.height), style: UITableViewStyle.Plain)
        self.mapClass = mapClass
        mapClass.view.addSubview(self)
        openWindow(self)
        
        var eventt: RLMResults = Event.objectsWhere("address = %@", mapClass.address)
        var tags: [Tag] = []
        
        if ((Event.objectsWhere("address = %@", mapClass.address).count != 0) &&  eventt[0] != nil ){
            
            event = eventt[0] as Event
            
            length = Int(event.tags.count + 1)
            
            // if there are less than 10 tags
//            if event.tags.count < 10 {
            
                
                
            for var i = 0; i < length - 1; i++ {
                
                tags.append(event.tags[UInt(i)] as Tag)
                
            }
                
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()

                
//                    var defaultTagg: RLMResults = Event.objectsWhere("address = %@", "default")
//                
//                    if ((Event.objectsWhere("address = %@", "default").count != 0) && defaultTagg[0] != nil){
//                
//                        var defaultTag = defaultTagg[0] as Event
//                
//                        length = Int(event.tags.count + defaultTag.tags.count)
//                
//                        for var j = Int(event.tags.count); j < Int(length); j++ {
//                
//                                tags.append(defaultTag.tags[UInt(j - Int(event.tags.count))] as Tag)
//                                event.tags.addObject(defaultTag.tags[UInt(j)] as Tag)
//                            
//                            println("we made it here")
//                                        
//                        }
//                        
//                    }
            
//                println("and here")
            tags.sort( {$0.weight > $1.weight } )
                
            for var i = 0; i < length - 1; i++ {
                
                println("the tags are: \(tags[i].name)")
                event.tags[UInt(i)] = tags[i]
                
            }
                                
            realm.commitWriteTransaction()
                
//            }
            //if there are more than 10 tags
//            else {
//                
//                for var i = 0; i < length; i++ {
//                    
//                    tags.append(event.tags[UInt(i)] as Tag)
//                    
//                }
//                
//                tags.sort( {$0.weight > $1.weight } )
//                
//                let realm = RLMRealm.defaultRealm()
//                realm.beginWriteTransaction()
//                
//                for var i = 0; i < length; i++ {
//                    
//                    println("the tags are: \(tags[i].name)")
//                    event.tags[UInt(i)] = tags[i]
//                    
//                }
//                
//                realm.commitWriteTransaction()
//                
//            }
            
        }
        else {
//
            var defaultTagg: RLMResults = Event.objectsWhere("address = %@", "default")
            
            if ((Event.objectsWhere("address = %@", "default").count != 0) && defaultTagg[0] != nil){
                
                event = defaultTagg[0] as Event
                
                length = Int(event.tags.count + 1)
                
                for var j = 0; j < length - 1; j++ {
                    
                    tags.append(event.tags[UInt(j)] as Tag)
                    
                }
                
                tags.sort( {$0.weight > $1.weight } )
                
                let realm = RLMRealm.defaultRealm()
                
                realm.beginWriteTransaction()
                for var i = 0; i < length - 1; i++ {
                    
                    println("the tags are: \(tags[i].name)")
                    event.tags[UInt(i)] = tags[i]
                    
                }
                
                realm.commitWriteTransaction()
                
            }
            
        }
    
    
        setUpTable()
        

    }
    
    deinit {
        println("TagSelectorTableView Deinit")
        
        mapClass = nil
        event = nil
    }
    
    func setUpTable(){

        super.delegate = self
        super.dataSource = self
        super.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        super.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        super.separatorStyle = .None
        super.backgroundColor = UIColor.clearColor()
        super.rowHeight = 38

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return length
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var alpha: CGFloat! = (1.0 - (0.7/CGFloat(length))*CGFloat(indexPath.row))
        
        if indexPath.row == 0 {
            
            println(indexPath)
            let cellID = "Create Cell"
            var cell:CreateTagViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? CreateTagViewCell
            
            if (cell == nil) {
                
                cell = CreateTagViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, mapClass: self.mapClass)
            }
            
            return cell
            
        }
        
        let cellID = "TagCell"
        var cell:TagButtonTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellID) as? TagButtonTableViewCell
        
        if (cell == nil) {
            
            cell = TagButtonTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID, mapClass: mapClass)
            
        }
        
        cell.backgroundButton.setTitle(event.tags[UInt(indexPath.row - 1)].name, forState: UIControlState.Normal)
        cell.fitToSize(22.0)
        
        cell.backgroundButton.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: alpha)
        
        
        return cell
    }
    
    //delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if indexPath.row == 0 {
            
            var cell: CreateTagViewCell! = tableView.cellForRowAtIndexPath(indexPath) as? CreateTagViewCell
            cell.newTag.becomeFirstResponder()
            println(cell.frame)
            println(cell.background.frame)
            
        } else {
            
            mapClass.tableView.endEditing(true)
            
        }
        
        println("You selected cell #\(indexPath.row)!")
        
    }
    
    func openWindow(moveView: UIView){
        
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            moveView.frame = CGRectMake(0, 62, moveView.frame.width, moveView.frame.height - 62)
            
            }, completion: ({ success in
                
                println("Window did appear")
                
            }))
        
    }
    
    func closeWindow(moveView: UIView){
        
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            moveView.frame = CGRectMake(-moveView.frame.width, 62, moveView.frame.width, moveView.frame.height - 62)
            
            }, completion: ({ success in
                
               println("Window was closed")
                
               self.mapClass.tableView.removeFromSuperview()
               self.mapClass.tableView = nil
               self.mapClass.mapView.showsUserLocation = true
                
            }))
        
    }
    

    
    
    
}

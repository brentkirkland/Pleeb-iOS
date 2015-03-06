//
//  LoginOrDrawerController.swift
//  Pleeb
//
//  Created by Brent Kirkland on 2/28/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit

public class LoginOrDrawerController: UIWindow {
    
    override init(frame: CGRect){
            super.init(frame: frame)
    }
    
    //private var newWindow: UIWindow!
    private var drawerController: DrawerController!
    
    
    //LOGIN
    init(win: UIWindow!){
        
        super.init()
        setLogin(win)
        
    }
    
    //MAP
    init(window: UIWindow!){
        
        super.init()
        changeRoot(window)
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeRoot(window: UIWindow!){
        
        window.rootViewController = getDrawer()
        
        window.backgroundColor = UIColor.whiteColor()
        window.makeKeyAndVisible()
        
    }
    
    public func setLogin(window: UIWindow!){
        
        window.tintColor = UIColor.whiteColor()
        
        window.rootViewController = SignUpLoginViewController(window: window)
        
        window.backgroundColor = UIColor.whiteColor()
        window.makeKeyAndVisible()
        
    }
    
    public func getDrawer() -> DrawerController{
        
        let leftSideDrawerViewController = ExampleLeftSideDrawerViewController()
        let centerViewController = ExampleCenterTableViewController()
        let rightSideDrawerViewController = ExampleRightSideDrawerViewController()
        
        let navigationController = UINavigationController(rootViewController: centerViewController)
        navigationController.restorationIdentifier = "ExampleCenterNavigationControllerRestorationKey"
        
        let rightSideNavController = UINavigationController(rootViewController: rightSideDrawerViewController)
        rightSideNavController.restorationIdentifier = "ExampleRightNavigationControllerRestorationKey"
        
        let leftSideNavController = UINavigationController(rootViewController: leftSideDrawerViewController)
        leftSideNavController.restorationIdentifier = "ExampleLeftNavigationControllerRestorationKey"
        
        var drawerController: DrawerController! = DrawerController(centerViewController: navigationController, leftDrawerViewController: leftSideNavController, rightDrawerViewController: rightSideNavController)
        
        drawerController.showsShadows = false
        
        drawerController.restorationIdentifier = "Drawer"
        drawerController.maximumRightDrawerWidth = 200.0
        drawerController.openDrawerGestureModeMask = .All
        drawerController.closeDrawerGestureModeMask = .All
        
        
        return drawerController
        
        }
    
}

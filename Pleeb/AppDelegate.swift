// Copyright (c) 2014 evolved.io (http://evolved.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//
//  LoginOrDrawerController.swift
//  Pleeb
//
//  Created by Brent Kirkland on 2/28/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import Realm

let globalURL: String! = "http://livv.net"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow!
    
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        // Inside your application(application:didFinishLaunchingWithOptions:)
        
        // Notice setSchemaVersion is set to 1, this is always set manually. It must be
        // higher than the previous version (oldSchemaVersion) or an RLMException is thrown
        RLMRealm.setSchemaVersion(1, forRealmAtPath: RLMRealm.defaultRealmPath(),
            withMigrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if oldSchemaVersion < 1 {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        // now that we have called `setSchemaVersion:withMigrationBlock:`, opening an outdated
        // Realm will automatically perform the migration and opening the Realm will succeed
        // i.e. RLMRealm.defaultRealm()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        
        var user: RLMResults = User.allObjects()
        
        if (user.count == 0) {
        
            LoginOrDrawerController(win: window)
        
        }
        else if (!(user[0]as User).complete) {
            
            LoginOrDrawerController(win: window)
        }
        else {
          
            LoginOrDrawerController(window: self.window)
            
        }
        return true
    }
    
    
    func switchToLogin() -> Void {
        
        LoginOrDrawerController(win: window)
        
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        
        return true
    }
    
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        if let key = identifierComponents.last as? String {
            if key == "Drawer" {
                return self.window.rootViewController as SignUpLoginViewController
            } else if key == "MapViewNavigationControllerRestorationKey" {
                return (self.window.rootViewController as DrawerController).centerViewController
            } else if key == "TheListiewRightControllerRestorationKey" {
                return (self.window.rootViewController as DrawerController).rightDrawerViewController
            } else if key == "SettingsViewLeftControllerRestorationKey" {
                return (self.window.rootViewController as DrawerController).leftDrawerViewController
            } else if key == "SettingsViewController" {
                if let leftVC = (self.window.rootViewController as? DrawerController)?.leftDrawerViewController {
                    if leftVC.isKindOfClass(UINavigationController) {
                        return (leftVC as UINavigationController).topViewController
                    } else {
                        return leftVC
                    }
                }
            } else if key == "TheListiewController" {
                if let rightVC = (self.window.rootViewController as? DrawerController)?.rightDrawerViewController {
                    if rightVC.isKindOfClass(UINavigationController) {
                        return (rightVC as UINavigationController).topViewController
                    } else {
                        return rightVC
                    }
                }
            } else if key == "Drawer" {
                return self.window.rootViewController
            }
        }
        
        return nil
    }
    
}


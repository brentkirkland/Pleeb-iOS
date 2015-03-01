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
//  AppDelegate
//  Pleeb
//
//  Edited by Brent Kirkland on 2/28/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow!
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        LoginOrDrawerController(win: window)
        
        return true
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
                return self.window.rootViewController
            } else if key == "ExampleCenterNavigationControllerRestorationKey" {
                return (self.window.rootViewController as DrawerController).centerViewController
            } else if key == "ExampleRightNavigationControllerRestorationKey" {
                return (self.window.rootViewController as DrawerController).rightDrawerViewController
            } else if key == "ExampleLeftNavigationControllerRestorationKey" {
                return (self.window.rootViewController as DrawerController).leftDrawerViewController
            } else if key == "ExampleLeftSideDrawerController" {
                if let leftVC = (self.window.rootViewController as? DrawerController)?.leftDrawerViewController {
                    if leftVC.isKindOfClass(UINavigationController) {
                        return (leftVC as UINavigationController).topViewController
                    } else {
                        return leftVC
                    }
                }
            } else if key == "ExampleRightSideDrawerController" {
                if let rightVC = (self.window.rootViewController as? DrawerController)?.rightDrawerViewController {
                    if rightVC.isKindOfClass(UINavigationController) {
                        return (rightVC as UINavigationController).topViewController
                    } else {
                        return rightVC
                    }
                }
            }
        }
        
        return nil
    }
    
}


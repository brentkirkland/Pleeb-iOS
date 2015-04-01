// DrawerBarButton.swift
// L I V V

import UIKit
import Foundation

public class DrawerBarButtonItem: UIBarButtonItem {
    
    let menuButton: AnimatedMenuButton
    
    // MARK: - Initializers
    
    public override init() {
        self.menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        super.init()
    }
    
    public init(target: AnyObject?, action: Selector) {
        self.menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.menuButton.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        super.init(customView: self.menuButton)
    }
    
    public required convenience init(coder aDecoder: NSCoder) {
        let barButtonItem = UIBarButtonItem(coder: aDecoder)
        self.init(target: barButtonItem.target, action: barButtonItem.action)
    }
    
    // MARK: - Animations
    
    public func animateWithPercentVisible(percentVisible: CGFloat, drawerSide: DrawerSide) {
        if let btn = self.customView as? AnimatedMenuButton {
            btn.animateWithPercentVisible(percentVisible, drawerSide: drawerSide)
        }
    }
}

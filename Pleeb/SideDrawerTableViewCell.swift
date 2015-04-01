// SideDrawerTableViewCell.swift
// L I V V

import UIKit

class SideDrawerTableViewCell: TableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        self.accessoryCheckmarkColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        let backgroundView = UIView(frame: self.bounds)
        backgroundView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        let backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        backgroundView.backgroundColor = backgroundColor
        
        self.backgroundView = backgroundView
        
        self.textLabel?.backgroundColor = UIColor.clearColor()
        self.textLabel?.textColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
    }
    
    override func updateContentForNewContentSize() {
        self.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
}

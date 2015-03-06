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

import UIKit

class SideDrawerSectionHeaderView: UIView {
    var title: String? {
        didSet {
            self.label?.text = self.title?.uppercaseString
        }
    }
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        self.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.label = UILabel(frame: CGRect(x: 15, y: CGRectGetMaxY(self.bounds) - 28, width: CGRectGetWidth(self.bounds) - 30, height: 22))
        self.label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        self.label.backgroundColor = UIColor.clearColor()
        self.label.textColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0)
        self.label.autoresizingMask = .FlexibleWidth | .FlexibleTopMargin
        self.addSubview(self.label)
        self.clipsToBounds = false
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let lineColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        CGContextSetLineWidth(context, 1.0)
        CGContextMoveToPoint(context, CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5)
        CGContextAddLineToPoint(context, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5)
        CGContextStrokePath(context)
    }
}

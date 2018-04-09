//
//  RepeatingControl.swift
//  Elephant
//
//  Created by Caelan Dailey on 2/21/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation

import UIKit

// Custom control that allows a user to select a day
// Just 7 buttons in  a row
// if you tab in certain location it knows which button based on x cord

class DaysControl: UIControl {
    
    // FORMAT FOR DAYS is INT ARRAY
    // 1 = set
    // 0 = NOT set
    private var daysType:[Int] = [1,0,0,0,0,0,0]
    
    var value: [Int] {
        get {
            return daysType
        }
        set {
            daysType = newValue
            setNeedsDisplay()
        }
    }
    
    // Draw days
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
       
        //Setup
        context.clear(bounds)
        context.setFillColor((backgroundColor ?? UIColor.white).cgColor)
        context.fill(bounds)
        
        let buttonOffset: CGFloat = self.bounds.height/3
        // Left border
        let leftBorder: CGRect = CGRect(x: 0, y: 0, width: self.bounds.width/2, height: self.bounds.height - buttonOffset)
        context.setFillColor(UIColor.darkGray.cgColor)
        context.fill(leftBorder)
        
        // Right border
        let rightBorder: CGRect = CGRect(x: self.bounds.width/2, y: 0, width: self.bounds.width/2, height: self.bounds.height - buttonOffset)
        
        context.fill(rightBorder)
        context.setFillColor(UIColor.white.cgColor)
        let boxInset:CGFloat = 2.0
        let space:CGFloat = (self.bounds.width - boxInset)/7
        
        // LOOPS THROUGH AND CREATES ALL BUTTONS
        for i in 0...6 {
            if daysType[i] == 0 {
                let leftBox: CGRect = CGRect(x: boxInset+space*CGFloat(i), y: boxInset, width: space - boxInset*2, height: self.bounds.height - boxInset*2 - buttonOffset)
                
                context.fill(leftBox)
                
            }
        }
        
        // Text
        // Configure
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        // Box
        let path = CGMutablePath()
        path.addRect(CGRect(x:self.bounds.width/4, y:0, width: self.bounds.width/2, height: self.bounds.height/4))
        
        // Styles
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        var styles: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.paragraphStyle.rawValue): style]
        styles[NSAttributedStringKey.font] = UIFont(name: "DINCondensed-Bold", size: 12 )
        styles[NSAttributedStringKey.foregroundColor] = UIColor.lightGray
        
        // set string
        let zone:String = "Days"
        
        // Create and draw
        var attribute = NSAttributedString(string: zone, attributes: styles)
        var setter = CTFramesetterCreateWithAttributedString(attribute as CFAttributedString)
        
        var frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attribute.length), path, nil)
        
        CTFrameDraw(frame, context)
        
        for i in 0...6 {
            var day = "M"
            switch(i) {
            case 0: day = "M"
            case 1: day = "T"
            case 2: day = "W"
            case 3: day = "TH"
            case 4: day = "F"
            case 5: day = "S"
            case 6: day = "S"
            default: day = "M"
            }
            
            let spacing = self.bounds.width/7
            attribute = NSAttributedString(string: day, attributes: styles)
            setter = CTFramesetterCreateWithAttributedString(attribute as CFAttributedString)
            let pathM = CGMutablePath()
            pathM.addRect(CGRect(x:spacing * CGFloat(i), y:self.bounds.height*3/8, width: self.bounds.width/7, height: self.bounds.height/4))
            frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attribute.length), pathM, nil)
            CTFrameDraw(frame, context)
            
        }

    }
    
    // TOUCHES
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first!
        let locationIsnSelf: CGPoint = touch.location(in: self)
       
        let div = self.bounds.width/7
        let pos = Int(locationIsnSelf.x/div)
        print(pos)
        daysType[pos] = daysType[pos]^1
        
        sendActions(for: .valueChanged)
        setNeedsDisplay()
    }
}

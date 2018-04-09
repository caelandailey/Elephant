//
//  RepeatingControl.swift
//  Elephant
//
//  Created by Caelan Dailey on 2/21/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//


import Foundation

import UIKit

// Custom control that allows a user to select a repeating time
// Slider control from left to right
class RepeatingControl: UIControl {
    
    private var repeaterType = "none"
    
    var value: String {
        get {
            return repeaterType
        }
        set {
            repeaterType = newValue
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        print(repeaterType)
        print("ABOVE")
        //Setup
        context.clear(bounds)
        context.setFillColor((backgroundColor ?? UIColor.white).cgColor)
        context.fill(bounds)
        
         let buttonOffset: CGFloat = self.bounds.height/3
        // Left border
        let leftBorder: CGRect = CGRect(x: 0, y: 0, width: self.bounds.width/3, height: self.bounds.height - buttonOffset)
        context.setFillColor(UIColor.darkGray.cgColor)
        context.fill(leftBorder)
        
        // Right border
        let rightBorder: CGRect = CGRect(x: self.bounds.width/3, y: 0, width: self.bounds.width/3, height: self.bounds.height - buttonOffset)
      
        context.fill(rightBorder)
        
        let otherBorder: CGRect = CGRect(x: self.bounds.width*2/3, y: 0, width: self.bounds.width/3, height: self.bounds.height - buttonOffset)
        
        context.fill(otherBorder)
        
        let boxInset:CGFloat = 2.0
       
        // Left box
        let leftBox: CGRect = CGRect(x: boxInset, y: boxInset, width: self.bounds.width/3 - boxInset*2, height: self.bounds.height - boxInset*2 - buttonOffset)
        if (repeaterType == "minute")
        {
            context.setFillColor(UIColor.lightGray.cgColor)
        } else {
        context.setFillColor(UIColor.white.cgColor)
        }
        context.fill(leftBox)
        
        let rightBox: CGRect = CGRect(x: boxInset+self.bounds.width/3, y: boxInset, width: self.bounds.width/3 - boxInset*2, height: self.bounds.height - boxInset*2 - buttonOffset)
        if (repeaterType == "hour")
        {
            context.setFillColor(UIColor.lightGray.cgColor)
        } else {
            context.setFillColor(UIColor.white.cgColor)
        }
        context.fill(rightBox)
        
        let otherBox: CGRect = CGRect(x: boxInset+self.bounds.width*2/3, y: boxInset, width: self.bounds.width/3 - boxInset*2, height: self.bounds.height - boxInset*2 - buttonOffset)
        if (repeaterType == "day")
        {
            context.setFillColor(UIColor.lightGray.cgColor)
        } else {
            context.setFillColor(UIColor.white.cgColor)
        }
        context.fill(otherBox)
        
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
        styles[NSAttributedStringKey.foregroundColor] = UIColor.darkGray
        
        // set string
        let zone:String = "When to repeat"
        
        // Create and draw
        var attribute = NSAttributedString(string: zone, attributes: styles)
        var setter = CTFramesetterCreateWithAttributedString(attribute as CFAttributedString)
        
        var frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attribute.length), path, nil)
        
        CTFrameDraw(frame, context)
        
        // left LABEL
        attribute = NSAttributedString(string: "Minutes", attributes: styles)
        setter = CTFramesetterCreateWithAttributedString(attribute as CFAttributedString)
        let pathM = CGMutablePath()
        pathM.addRect(CGRect(x:self.bounds.width/10, y:self.bounds.height*3/8, width: self.bounds.width/10, height: self.bounds.height/4))
        frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attribute.length), pathM, nil)
        CTFrameDraw(frame, context)
        
        // right LABEL
        attribute = NSAttributedString(string: "Hours", attributes: styles)
        setter = CTFramesetterCreateWithAttributedString(attribute as CFAttributedString)
        let pathS = CGMutablePath()
        pathS.addRect(CGRect(x:self.bounds.width - self.bounds.width*6/10, y:self.bounds.height*3/8, width: self.bounds.width/10, height: self.bounds.height/4))
        frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attribute.length), pathS, nil)
        CTFrameDraw(frame, context)
        
        // other LABEL
        attribute = NSAttributedString(string: "Days", attributes: styles)
        setter = CTFramesetterCreateWithAttributedString(attribute as CFAttributedString)
        let pathO = CGMutablePath()
        pathO.addRect(CGRect(x:self.bounds.width - self.bounds.width/8, y:self.bounds.height*3/8, width: self.bounds.width/10, height: self.bounds.height/4))
        frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attribute.length), pathO, nil)
        CTFrameDraw(frame, context)
    }
    
    // TOUCHES

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first!
        let locationIsnSelf: CGPoint = touch.location(in: self)
        
        if (locationIsnSelf.y > self.bounds.height - 4 - self.bounds.height/3)
        {
            return
        }
        if (locationIsnSelf.x < self.bounds.width/3)
        {
            if (repeaterType == "minute") {
                repeaterType = "none"
            }else {
                repeaterType = "minute"
            }
        } else if (locationIsnSelf.x > self.bounds.width/3 && locationIsnSelf.x < self.bounds.width*2/3) {
            if (repeaterType == "hour")
            {
                repeaterType = "none"
            } else {
                repeaterType = "hour"
            }
        } else  {
            if (repeaterType == "day")
            {
                repeaterType = "none"
            } else {
                repeaterType = "day"
            }
        }
        
        sendActions(for: .valueChanged)
        setNeedsDisplay()
    }
}

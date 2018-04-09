//
//  ZoneControl.swift
//  Alarm
//
//  Created by Caelan Dailey on 2/6/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

// Custom control that allows a user to select a time zone
// Slider control from left to right
class ZoneControl: UIControl {
    
    private var position: CGFloat = 30.0
    private var offSet: CGFloat = 30.0
    private let lineHeight: CGFloat = 8.0
    private var knobHeight: CGFloat = 0.0
    private var spot: Int = 0
    var value: Int {
        get {
            let range = position-offSet
            let space = self.bounds.width - offSet * 2 - knobHeight
            let spots: CGFloat = 8      // 9-1 = 8
            
            return Int(range/(space/spots))
        }
        set {
            spot = newValue
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        
        //Setup
        context.clear(bounds)
        context.setFillColor((backgroundColor ?? UIColor.white).cgColor)
        context.fill(bounds)
        
        knobHeight = self.bounds.height/2
        let space = self.bounds.width - offSet * 2 - knobHeight
        position = offSet + (space/9) * CGFloat(spot)
        
        // Line border
        let topBorder: CGRect = CGRect(x: 0, y: 0, width: self.bounds.width , height: 1)
        context.setFillColor(UIColor.lightGray.cgColor)
        context.fill(topBorder)
        
        // LineBorder
        let lineBorder: CGRect = CGRect(x: offSet-1, y: knobHeight - lineHeight/2 + -1, width: self.bounds.width - offSet*2+2, height: lineHeight+2)
        context.setFillColor(UIColor.darkGray.cgColor)
        context.fill(lineBorder)
        
        // Line
        let lineFrame: CGRect = CGRect(x: offSet, y: knobHeight - lineHeight/2, width: self.bounds.width - offSet*2, height: lineHeight)
        context.setFillColor(UIColor(red: 245/256, green: 245/256, blue: 245/256, alpha: 1.0).cgColor)
        context.fill(lineFrame)
        
        // LineFill
        let lineFillFrame: CGRect = CGRect(x: offSet, y: knobHeight - lineHeight/2, width: position-offSet, height: lineHeight)
        context.setFillColor(UIColor.darkGray.cgColor)
        context.fill(lineFillFrame)
        
        /// NobBorder
        let borderSize: CGFloat = 2.0
        
        let nobBorder: CGRect = CGRect(x: position-borderSize, y: (knobHeight/2) - borderSize , width: (knobHeight) + borderSize * 2, height: (knobHeight) + borderSize * 2)
        context.setFillColor(UIColor.darkGray.cgColor)
        context.fillEllipse(in: nobBorder)
        
        // Nob
        context.setFillColor(UIColor.white.cgColor)
        let nobFrame: CGRect = CGRect(x:position, y:knobHeight/2 , width: knobHeight, height: self.bounds.height/2)
        context.fillEllipse(in: nobFrame)
        
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
        let zone:String?
        switch (value) {
        case 0: zone = "AST"
        case 1: zone = "EST"
        case 2: zone = "CST"
        case 3: zone = "MST"
        case 4: zone = "PST"
        case 5: zone = "AKST"
        case 6: zone = "HST"
        case 7: zone = "UTC-11"
        case 8: zone = "UTC+10"
        default: zone = "AST"
        }
        
        // Create and draw
        var attribute = NSAttributedString(string: zone!, attributes: styles)
        var setter = CTFramesetterCreateWithAttributedString(attribute as CFAttributedString)
        
        var frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attribute.length), path, nil)
        
        CTFrameDraw(frame, context)
        
        // left LABEL
        attribute = NSAttributedString(string: "AST", attributes: styles)
        setter = CTFramesetterCreateWithAttributedString(attribute as CFAttributedString)
        let pathM = CGMutablePath()
        pathM.addRect(CGRect(x:0, y:self.bounds.height*3/8, width: offSet, height: self.bounds.height/4))
        frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attribute.length), pathM, nil)
        CTFrameDraw(frame, context)
        
        // right LABEL
        attribute = NSAttributedString(string: "UTC", attributes: styles)
        setter = CTFramesetterCreateWithAttributedString(attribute as CFAttributedString)
        let pathS = CGMutablePath()
        pathS.addRect(CGRect(x:self.bounds.width - offSet, y:self.bounds.height*3/8, width: offSet, height: self.bounds.height/4))
        frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attribute.length), pathS, nil)
        CTFrameDraw(frame, context)
    }
    
    // TOUCHES
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let touch: UITouch = touches.first!
        let locationIsnSelf: CGPoint = touch.location(in: self)
        
        let location = locationIsnSelf.x - knobHeight/2
        if (location < 0 + offSet) {
            position = 0 + offSet
        } else if (location > (self.bounds.width - knobHeight) - offSet) {
            position = (self.bounds.width - knobHeight) - offSet
        } else {
            position = location
        }
        
        let range = position-offSet
        let space = self.bounds.width - offSet * 2 - knobHeight
        let spots: CGFloat = 8  // 120 - 1
        spot = Int(1 + range/(space/spots))

        sendActions(for: .valueChanged)
        setNeedsDisplay()
    }
}

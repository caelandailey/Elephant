//
//  ClockView.swift
//  Alarm
//
//  Created by Caelan Dailey on 2/7/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class ClockView: UIView {
    
    // Get initial times. WHATS HAPPENING HERE?
    // Get seconds from data, / 60 to get position
    // Multiply %%% by 2.0 * CGFloat.pi to get physical position on clock
    private var secondsAngle = CGFloat(Calendar.current.component(.second, from: Date())) * 2.0 * CGFloat.pi / 60 + CGFloat.pi * 1.5
    private var minutesAngle = CGFloat(Calendar.current.component(.minute, from: Date())) * 2.0 * CGFloat.pi / 60 + CGFloat.pi * 1.5
    private var hoursAngle = CGFloat(Calendar.current.component(.hour, from: Date())) * 2.0 * CGFloat.pi / 12 + CGFloat.pi * 1.5
    
    // PI(3.1415) starts at the 3 on the clock. Needs to be adjusted to start at noon
    private let offSet = CGFloat.pi * 1.5 // GETS THE CLOCK TO START AT NOON
    private var timer: Timer?
   
    // Required
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TIMER FOR CLOCK
    // Updates once a second
    override init(frame: CGRect) {
        super.init(frame: frame)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    
    // ACTION FOR CLOCK
    // GETS seconds from date and calculates position
    // Offset needed so it doesnt start at 3o'clock position
    @objc func updateClock() {
        let seconds = CGFloat(Calendar.current.component(.second, from: Date()))
        secondsAngle = seconds * 2.0 * CGFloat.pi / 60 + offSet
        let minutes = CGFloat(Calendar.current.component(.minute, from: Date()))
        minutesAngle = minutes * 2.0 * CGFloat.pi / 60 + offSet
        let hours = (Calendar.current.component(.hour, from: Date()))%12
        hoursAngle = ((CGFloat(hours) * 2.0 * CGFloat.pi) / 12) + offSet
        
        setNeedsDisplay()
    }
    
    // All work is done here
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        
        //Setup
        context.clear(bounds)

        // Border
        let color = UIColor(red: 51/256, green: 51/256, blue: 51/256, alpha: 1.0)
        context.setFillColor(color.cgColor)
        let clockBorder = CGRect(x:0, y:0, width: bounds.width, height: bounds.height)
        context.fillEllipse(in: clockBorder)
        
        // Clock inside
        context.setFillColor(UIColor(red: 253/256, green: 253/256, blue: 253/256, alpha: 1.0).cgColor)
        let clock = CGRect(x:4, y:4, width: bounds.width - 8, height: bounds.height - 8)
        context.fillEllipse(in: clock)
        
        // TICKS ON CLOCK
        for i in 0...59 {
            
            var radius:CGFloat = 0.5
            var thickness = 3
            
            // top of tick
            let pos = CGFloat.pi*2.0 * CGFloat(i) / 60
            let topX = (self.bounds.midX + (self.bounds.width * radius * cos(pos)))
            let topY = (self.bounds.midX + (self.bounds.width * radius * sin(pos)))
            
            // Adjust these to adjust ticks size and thickness
            if (i % 5 == 0) {
                radius = 0.435
                thickness = 4
            } else {
                radius = 0.46
            }
            
            // bottom of tick
            let botX = (self.bounds.midX + (self.bounds.width * radius * cos(CGFloat.pi*2.0 * CGFloat(i) / 60)))
            let botY = (self.bounds.midX + (self.bounds.width * radius * sin(CGFloat.pi*2.0 * CGFloat(i) / 60)))
            
            let color = UIColor(red: 51/256, green: 51/256, blue: 51/256, alpha: 1.0)
            
            // Draw it
            drawLine(x1: topX, y1: topY, x2: botX, y2: botY, color: color , width: thickness)
            
        }
        
        // MINUTES ANGLE ----------------------------
        var x2 = bounds.width/2
        var y2:CGFloat = bounds.height/2 // Center
        var radius: CGFloat = self.bounds.width * 0.475
        
        var x1 = (self.bounds.midX + (radius * cos(CGFloat(minutesAngle))))
        var y1 = (self.bounds.midY + (radius * sin(CGFloat(minutesAngle))))
        
        drawLine(x1: x1, y1: y1, x2: x2, y2: y2, color: UIColor.black, width: 5)
        
        // HOUR ANGLE ----------------------------
        radius = self.bounds.width * 0.35
        
        x1 = (self.bounds.midX + (radius * cos(CGFloat(hoursAngle))))
        y1 = (self.bounds.midY + (radius * sin(CGFloat(hoursAngle))))
        
        drawLine(x1: x1, y1: y1, x2: x2, y2: y2, color: UIColor.black, width: 5)
        
        // DOT IN MIDDLE ----------------------------
        var dotSize: CGFloat = self.bounds.height/14
        let dot: CGRect = CGRect(x: self.bounds.midX - dotSize/2, y: self.bounds.midY-dotSize/2, width: dotSize,height: dotSize)
        context.setFillColor(UIColor.black.cgColor)
        
        context.fillEllipse(in: dot)
        
        // SECONDS ANGLE ----------------------------
        radius = self.bounds.width * 0.475
        
        x1 = (self.bounds.midX + (radius * cos(CGFloat(secondsAngle))))
        y1 = (self.bounds.midY + (radius * sin(CGFloat(secondsAngle))))
        
        x2 = (bounds.width / 2) - (radius * cos(CGFloat(secondsAngle))/10)
        y2 = (bounds.height / 2) - (radius * sin(CGFloat(secondsAngle))/10) // Center
        
        drawLine(x1: x1, y1: y1, x2: x2, y2: y2, color: UIColor.red, width: 3)   // Seconds
        
        // RED DOT IN MIDDLE ----------------------------
        dotSize = self.bounds.height/28
        
        let redDot: CGRect = CGRect(x: self.bounds.midX - dotSize/2, y: self.bounds.midY-dotSize/2, width: dotSize,height: dotSize)
        
        context.setFillColor(UIColor.red.cgColor)
        
        context.fillEllipse(in: redDot)
        

        // TEXTTTTT ----------------------------
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
        styles[NSAttributedStringKey.font] = UIFont(name: "DINCondensed-Bold", size: self.bounds.height/10 )
        styles[NSAttributedStringKey.foregroundColor] = UIColor.darkGray
        
        // See if PM OR AM
        var theTime:String = "PM"
        if (Int((Calendar.current.component(.hour, from: Date()))/12) == 0) {
            theTime = "AM"
        }
       
        
        // Create and draw
        let attribute = NSAttributedString(string: theTime, attributes: styles)
        let setter = CTFramesetterCreateWithAttributedString(attribute as CFAttributedString)
        
        let frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, attribute.length), path, nil)
        
        CTFrameDraw(frame, context)
    }
    
    // Helper function to draw a line between 2 points with width and color
    private func drawLine(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, color: UIColor, width: Int) {
        
        let sLine = UIBezierPath()

        sLine.move(to: CGPoint(x: x1, y: y1)) // Point A
        
        sLine.addLine(to: CGPoint(x:x2, y: y2)) // Point B
        
        sLine.lineWidth = CGFloat(width)    // Set width
        sLine.close()
        
        color.set()         // Set color
        sLine.stroke()  // Draw line
        sLine.fill()    // Fill it
    }  
}

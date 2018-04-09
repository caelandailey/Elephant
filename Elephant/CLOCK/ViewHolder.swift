//
//  MainView.swift
//  Alarm
//
//  Created by Caelan Dailey on 2/6/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//
//
//  Created for CS 4530-002 Spring 2018 Mobile App Programming
//  Project 1 - Alarm
//
// CLOCK DOES WORK IN REAL TIME using timer and Date()

/*
 
ASSIGNMENT DETAILS
Main Composite View - A grouping view which contains the other views. Must inherit from UIView or UIControl and must include public properties to programmatically get and set values for the following properties:
 
Alarm Time - An alarm time represented as a TimeInterval representing seconds since midnight within a single day. Assume all days have exactly 86400 seconds.
 
Alarm Duration - A value expressed as a TimeInterval which represents the number of seconds for which an alarm will sound. Supported values must be between 1 and 120 seconds.
 
Alarm Days - A set of enum values which represents the days of the week on which the alarm will occur.
 
Alarm Time Zone - An enum value indicating which time zone the alarm occurs in.
 */

/*
  This project creates the UI for an alarm
The project requested a custom clock UI and a custom control
 For my clock:
    - Seconds
    - Minutes
    - Hours
    - Realtime
    - Created using CoreGraphics API
    - CoreGraphics label for AM or PM
    - UI Ticks for each second on clock
 
 For my control:
    - Custom UI Slider
 How it works:
    - Moves nib on the x axis where you place your finger in the view
    - Has offsets on the left and right to place it in the center
    - Size of nib is custom
    - Size of bar is custom
    - Bar fills it when moves
 Looks:
    - Has labels on left and right describing the bottom and top limits
    - Has value label on bottom showing CURRENT position
 
 HOW TO IMPROVE:
    All 3 of my duraction, day, and zone controls are the same custom control
    In the future it would be possible to customize the control to where you can edit the labels, size, and outputs, etc.
    To where the slider could look any color and be anysize, etc.
 
 CONCERNS: Maybe for grader too
    Not sure what the point of the GET and SET values are in the Main Composite View
    My labels of the days, time, duration are all in the controls themselves.
 */

/*
 FEB 22
 MANY CONTROLS WERE CHANGE SINCE THE LAST ASSIGNMENT
 DAYS CAN NOW SELECT MULTIPLE DAYS AND IS A BUTTON NOT A SLIDER
 ADDED A REPEATER CONTROL
 ADDED A NAME CONTROL
 SOME ARCHITECTURE CHANGES
 
 */


import Foundation
import UIKit

class ViewHolder: UIView, UITextFieldDelegate {
    
    // Private variables
    private var duration: TimeInterval = 0
    private var theTime: TimeInterval = 0
    private var days: [Int] = [1,0,0,0,0,0,0]
    private var zone: Int = 0
    private var repeater: String = "none"
    private var name:String = "Alarm"
    
    // GETTER AND SETTER
    
    var currentRepeater: String {
        get {
            return repeater
        } set {
            repeatingControl.value = newValue
            repeater = newValue
            
        }
    }
    
    var clockTime: TimeInterval {
        
        get {
            return theTime
        }
        set {
            
            
        }
    }
    
    var currentDays: [Int] {
    
        get {
            return days
        } set {
            daysControl.value = newValue
            days = newValue
            
        }
    }
    
    var currentZone: Int {
        get {
            return zone
        }set {
            zone = newValue
            zoneControl.value = newValue
        }
        
    }
    
    var alarmDuration: TimeInterval {
        get {
            return duration
        }
        set {
            durationControl.value = newValue
            duration = newValue
        }
    }
    
    var alarmTime: TimeInterval {
        get {
            return theTime
        }
        set {
            //timeControl.value = newValue
            let hour: Int = Int(newValue/3600)
            let minute: Int = (Int(newValue) - (hour)*3600) / 60
            var minuteString = String(minute)
            if (minute < 10) {
                minuteString = "0\(minute)"
            }
            var hourString = String(hour)
            if (hour < 10) {
                hourString = "0\(hour)"
            }
           
            let dateString = hourString + ":" + minuteString
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.date(from: dateString)
            
            if let newDate = date {
                timeControl.setDate(newDate, animated: false)
            }
            
            
            theTime = newValue
        }
    }
    
    var alarmName: String {
        get {
            return name
        }
        set {
            if (nameControl.text == "") {
                name = "Alarm"
            }
            nameControl.text = newValue
            name = newValue
        }
    }
    
    // Views and Controls
    
    let nameControl: NameControl = {
        let nameControl = NameControl()
        nameControl.translatesAutoresizingMaskIntoConstraints = false
        return nameControl
    }()
    
    let clockView: ClockView = {
        let clockView = ClockView()
        clockView.translatesAutoresizingMaskIntoConstraints = false
        return clockView
    }()
    
    let timeControl: TimeControl = {
        let timeControl = TimeControl()
        timeControl.translatesAutoresizingMaskIntoConstraints = false
        return timeControl
    }()
    
    let daysControl: DaysControl = {
        let daysControl = DaysControl()
        daysControl.translatesAutoresizingMaskIntoConstraints = false
        return daysControl
    }()
    
    let durationControl: DurationControl = {
        let durationControl = DurationControl()
        durationControl.translatesAutoresizingMaskIntoConstraints = false
        return durationControl
    }()
    
    let zoneControl: ZoneControl = {
        let zoneControl = ZoneControl()
        zoneControl.translatesAutoresizingMaskIntoConstraints = false
        return zoneControl
    }()
    
    let repeatingControl: RepeatingControl = {
        let repeatingControl = RepeatingControl()
        repeatingControl.translatesAutoresizingMaskIntoConstraints = false
        return repeatingControl
    }()
    
    
    // MODIFY BACKGROUND COLORS
    override var backgroundColor: UIColor? {
        didSet {
            let whiteColor = UIColor(red: 251/256, green: 251/256, blue: 251/256, alpha: 1.0)
            zoneControl.backgroundColor = whiteColor
            daysControl.backgroundColor = whiteColor
            clockView.backgroundColor = UIColor(red: 245/256, green: 245/256, blue: 245/256, alpha: 1.0)
            durationControl.backgroundColor = whiteColor
            timeControl.backgroundColor = whiteColor
            repeatingControl.backgroundColor = whiteColor
            nameControl.backgroundColor = whiteColor
        }
    }
    
    //ADD SUBVIEWS AND TARGETS
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(zoneControl)
        addSubview(daysControl)
        addSubview(clockView)
        addSubview(durationControl)
        addSubview(timeControl)
        addSubview(repeatingControl)
        addSubview(nameControl)
        zoneControl.addTarget(self, action: #selector(zoneControlChanged), for: .valueChanged)
        daysControl.addTarget(self, action: #selector(daysControlChanged), for: .valueChanged)
        durationControl.addTarget(self, action: #selector(durationControlChanged), for: .valueChanged)
        timeControl.addTarget(self, action: #selector(timeControlChanged), for: .valueChanged)
        repeatingControl.addTarget(self, action: #selector(repeatingControlChanged), for: .valueChanged)
        nameControl.addTarget(self, action: #selector(nameControlChanged), for: .editingChanged)
        nameControl.delegate = self
        
        let date = timeControl.date
        let c = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        
        if let hour = c.hour, let minute = c.minute, let second = c.second {
            alarmTime = TimeInterval(hour*3600 + minute*60 + second)
        }
        
    }
    
    // OPENS KEYBOARD
    // DOESNT WORK SOMETIMES?
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    
    // USER DONE SO CLOSE KEYBOARD
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
  
    
    // THANKS APPLE
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // CREATE VIEW POSITIONS
    // HOW IT WORKS:
    // if vertical: Put controls below
    // if horizontal: Put controls to the right
    // Adjust cursor based on orientation
    override func layoutSubviews() {
        var cursor: CGPoint = .zero
        var length: CGFloat = 0.0
        var offSet:CGFloat = 0
        var newWidth: CGFloat = 0
        
        
        // If horizontal or verticles
        if bounds.width > bounds.height {
            length = bounds.height
            offSet = bounds.height/20
        } else {
            length = bounds.width
            offSet = bounds.width/20
        }
        
        // CLOCK
        clockView.frame = CGRect(x: offSet + length/2 - (length*(2/10)), y: offSet, width: length*(2/5) - offSet*2, height: length*(2/5) - offSet*2)
        
        // If horizontal or verticles
        if bounds.width > bounds.height {
            // SHIFT TO THE RIGHT
            cursor.x += bounds.height
            length = (bounds.height)/4
            newWidth = bounds.width - bounds.height
        } else {
            // SHIFT DOWN
            cursor.y += bounds.width * (2/5)
            length = (bounds.height - bounds.width*(2/5))/6
            newWidth = bounds.width
        }
       
        // CONTROLS
        nameControl.frame = CGRect(x: cursor.x, y: cursor.y, width: newWidth, height: length)
        cursor.y += length
        durationControl.frame = CGRect(x: cursor.x, y: cursor.y, width: newWidth, height: length)
        cursor.y += length
        daysControl.frame = CGRect(x: cursor.x, y: cursor.y, width: newWidth, height: length)
        cursor.y += length
        zoneControl.frame = CGRect(x: cursor.x, y: cursor.y, width: newWidth, height: length)
        cursor.y += length
        repeatingControl.frame = CGRect(x: cursor.x, y: cursor.y, width: newWidth, height: length)
        cursor.y += length
        timeControl.frame = CGRect(x: cursor.x, y: cursor.y, width: newWidth, height: length)
        // Subviews not being reloaded when rotating. need to add these
        zoneControl.setNeedsDisplay()
        timeControl.setNeedsDisplay()
        durationControl.setNeedsDisplay()
        repeatingControl.setNeedsDisplay()
        daysControl.setNeedsDisplay()
        nameControl.setNeedsDisplay()
    }
    
    
    // ___________________________________________________________________ACTIONS
    
    // Control for textfield to make alarm name
    @objc func nameControlChanged(sender: NameControl) {
        if let alarmName = sender.text {
            name = alarmName
            
            print(name)
        }
    }
    // GET DURATION VALUE HERE
    // RECIEVED AS INTEGER VALUE BETWEEN 1-120
    @objc func durationControlChanged(sender: DurationControl) {
       duration = TimeInterval(sender.value)
    }
    
    // GET TIME VALUE HERE
    // POSSIBLE VALUES: 12:00AM - 11:59PM
    // SENT AS A DATE
    @objc func timeControlChanged(sender: UIDatePicker) {
        let date = sender.date
        let c = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        
        if let hour = c.hour, let minute = c.minute, let second = c.second {
            theTime = TimeInterval(hour*3600 + minute*60 + second)
        }
    }
    
    // GET DAY VALUE HERE:
    // POSSIBLE VALUES: INTEER FROM 0-6
    @objc func daysControlChanged(sender: DaysControl) {
        print("dayscontrolchanged")
        print(sender.value)
        days = sender.value
        print(days)
    }
    
    // GET ZONE VALUE HERE
    // VALUES FROM 0-8 AS AN INTEGER
    @objc func zoneControlChanged(sender: ZoneControl) {
       zone = sender.value
    }
    
    @objc func repeatingControlChanged(sender: RepeatingControl) {
        repeater = sender.value
    }
}

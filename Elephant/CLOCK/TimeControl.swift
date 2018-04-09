//
//  TimeControl.swift
//  Alarm
//
//  Created by Caelan Dailey on 2/6/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

// Time picker class for mainView. Used to select time of day
class TimeControl: UIDatePicker {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Assume local for now
        self.timeZone = NSTimeZone.local
        self.backgroundColor = UIColor.white
        
        // Make sure its only time and not days
        self.datePickerMode = UIDatePickerMode.time
    }
}

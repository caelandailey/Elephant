//
//  NameControl.swift
//  Elephant
//
//  Created by Caelan Dailey on 2/21/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//
// TEXTFIELD TO CREATE ALARM NAME
//
import UIKit

class NameControl: UITextField {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.placeholder = "alarm name"
        self.textAlignment = NSTextAlignment.center
        self.textColor = UIColor.black
        self.backgroundColor = UIColor.white
    }
    
 
    
    
    
}

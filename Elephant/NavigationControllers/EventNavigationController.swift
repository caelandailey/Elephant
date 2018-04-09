//
//  EventNavigationController.swift
//  Elephant
//
//  Created by Caelan Dailey on 2/21/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import UIKit

// NAVIGATION CONTROLLER FOR EVENTS
// Controls navigation for events
// events don't navigate, but easier to just compy alarm navigation controller

class EventNavigationController: UINavigationController {
    
    
    override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)
        
        // Button for bottom tab bar
        self.tabBarItem = eventListButton
        self.navigationBar.barTintColor = .orange
    }
    
    // Required?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Bottom tab bar item
    let eventListButton : UITabBarItem = {
        let eventListButton = UITabBarItem()
        eventListButton.title = "Events"
        eventListButton.image = UIImage(named: "event_icon")
        
        return eventListButton
    }()
    
}

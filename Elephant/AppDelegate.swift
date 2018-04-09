//
//  AppDelegate.swift
//  Elephant
//
//  Created by Caelan Dailey on 2/20/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//
// Project 2 - Elephant Alarm
// An iOS app written in SWIFT that alerts the user of scheduled events
// Has a list of alarms and events on seperate tables
// user can create and delete alarms
// Used to keep track of events
// SAVES ALARMS AND EVENTS TO FILE
// Loads these on foreground changes

// Created by Caelan Dailey FEB 22 for CS 4530-002 Spring 2018
//
// Concerns: My representation of data is horrid. Int array for days, etc. Not sure how else to do it
// Saving information is done by converting everything to a string, saving. Then reading and parsing the string

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Create time file in order to calculate the current time when in foreground
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath: String = documentsPath + "/time.txt"
        let toWrite: String = ""
        let writer = toWrite as NSString
        
        try! writer.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8.rawValue)
        
        window?.backgroundColor = UIColor(red: 245/256, green: 245/256, blue: 245/256, alpha: 1.0)

        // Create controllers
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = UIColor.blue
        
        let alarmTableViewController = AlarmTableViewController()
        let eventTableViewController = EventTableViewController()
        
        let alarmNavigationController = AlarmNavigationController(rootViewController: alarmTableViewController)
        let eventNavigationController = EventNavigationController(rootViewController: eventTableViewController)
        
        tabBarController.viewControllers = [alarmNavigationController, eventNavigationController]
        tabBarController.selectedViewController = alarmNavigationController
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("Entering background")
        var documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        var filePath: String = documentsPath + "/events.txt"
        
        var toWrite: String = ""
        for i in 0..<EventDataset.count {
            toWrite = toWrite + EventDataset.entry(atIndex: i).name + " "
                + EventDataset.entry(atIndex: i).day + " "
                + String(EventDataset.entry(atIndex: i).time) + " "
        }
        print("WRITING events BELOW------")

        var writer = toWrite as NSString
        try! writer.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8.rawValue)
        documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        filePath = documentsPath + "/alarms.txt"
        
        var alarmString = ""
        for i in 0..<AlarmDataset.count {
            alarmString += AlarmDataset.entry(atIndex:  i).name
            alarmString += " "
            let daysList = AlarmDataset.entry(atIndex: i).days
            for i in 0..<daysList.count {
                alarmString += String(daysList[i])
            }
            alarmString += " "
            alarmString += AlarmDataset.entry(atIndex: i).repeater
            alarmString += " "
            alarmString += String(AlarmDataset.entry(atIndex: i).zone)
            alarmString += " "
            alarmString += String(AlarmDataset.entry(atIndex: i).duration)
            alarmString += " "
            alarmString += String(AlarmDataset.entry(atIndex: i).time)
            alarmString += " "
        }


        writer = alarmString as NSString
        
        try! writer.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8.rawValue)

        
       
        print("Finished writing")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("Entering foreground")
        
        print("started reading")
        
        // Loading all alarms and events so delete
        AlarmDataset.deleteAll()
        EventDataset.deleteAll()
        
        // Load from event text
        var documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        var filePath: String = documentsPath + "/events.txt"
        var read: NSString = try! NSString.init(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
        print("READING events BELOW------")

        // Conver to string array
        var list = String(read).split{$0 == " "}.map(String.init)
        
        // Loop through string array
        // 3 = is how many items in object
        var i = 0
        while (i < list.count) {
            EventDataset.appendEntry(EventDataset.Entry(name: list[i], day: list[i+1], time: TimeInterval(list[i+2])! ))
            i += 3
        }
        
        // Get alarms now
        documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        filePath = documentsPath + "/alarms.txt"
        read = try! NSString.init(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
        print("READING alarms BELOW------")

        // Split into array
        list = (read as String).split{$0 == " "}.map(String.init)
        
        i = 0
        
        // GO through array
        while (i < list.count) {
            let nums = list[i+1]
            var numsArray: [Int] = []
            
            // Convert [1,0,0,0,0,0,0] into 1000000
            for num in nums {
                numsArray.append(Int(String(num)) ?? 0)
            }

            // Create object
            // 6 = single object
            AlarmDataset.appendEntry(AlarmDataset.Entry(name: list[i], days: numsArray, repeater: list[i+2], zone: Int(list[i+3])!, duration: TimeInterval(list[i+4])!, time: TimeInterval(list[i+5])!))
            i += 6
        }
 
        // Save time
        filePath = documentsPath + "/time.txt"
        read = try!  NSString.init(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)

        // if time then create event
        if (read.length > 0)
        {
        createEvents(read)
        }
        
        // Write date afterwards
        print("writing date")
        documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        filePath = documentsPath + "/time.txt"
        let timeString = String(Int(Date().timeIntervalSince1970))
        
        try! (timeString as NSString).write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8.rawValue)
        
        
        print("finished reading")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    // Creates events when application enters foreground
    // Takes in the time when application entered foreground
    func createEvents(_ lastTime: NSString) {

        // Time since last
        let curr = Date().timeIntervalSince1970
        let diff = Int(curr) - Int(String(lastTime))!
        
        // Get day of week
        let components = Calendar.current.dateComponents([.weekday], from: Date())
        
        let day =  components.weekday! - 1

        print("thediffbelow")
        print(diff)
        
        // Go through alarms
        for i in 0..<AlarmDataset.count {
            let entry = AlarmDataset.entry(atIndex: i)
            
            var daysList = entry.days
            
            // Go through days its set
            for j in 0..<daysList.count {

                // If set go through repeaters
                if (daysList[j] == 1) {
                    if (entry.repeater == "none") {
                        if (diff >= Int(entry.duration)) {
                            EventDataset.appendEntry(EventDataset.Entry(
                                name: entry.name, day: getWeekDay(i),
                                time: entry.time+entry.duration))
                        }
                    } else if (entry.repeater == "minute") {
                        var tempDiff = diff
                        var addDiff = Int(entry.time+entry.duration)
                        if (tempDiff >= Int(entry.duration)) {
                            EventDataset.appendEntry(EventDataset.Entry(
                                name: entry.name, day: getWeekDay(i),
                                time: TimeInterval(addDiff)))
                            
                            addDiff = Int(entry.duration) + 60
                            tempDiff -= Int(entry.duration)
                            tempDiff -= 60
                        }
                    } else if (entry.repeater == "hour") {
                        var tempDiff = diff
                        var addDiff = Int(entry.time+entry.duration)
                        if (tempDiff >= Int(entry.duration)) {
                            EventDataset.appendEntry(EventDataset.Entry(
                                name: entry.name, day: getWeekDay(i),
                                time: TimeInterval(addDiff)))
                            addDiff = Int(entry.duration) + 3600
                            tempDiff -= Int(entry.duration)
                            tempDiff -= 3600
                        }
                    } else if (entry.repeater == "day") {
                        let daysDiff = day - i
                        if (daysDiff >= 0 && Int(entry.duration) <= (diff - 3600*24*(daysDiff))) {
                            EventDataset.appendEntry(EventDataset.Entry(
                                name: entry.name, day: getWeekDay(i),
                                time: entry.time+entry.duration))
                        }
                        for p in j..<daysList.count {   // Set to all 1's
                            daysList[p] = 1
                        }
                    }
                }
            }
        }
    }

    // Helper function to get days of week string
    // DAYS is an array of [0,1,0,0,0,0,0] Where 1 = is set
    // Need a way to convert to string
    // Current days int array is probably bad format.
    private func getWeekDay(_ pos: Int) -> String {
        switch(pos) {
        case 0: return "Monday"
        case 1: return "Tuesday"
        case 2: return  "Wednesday"
        case 3: return  " Thursday"
        case 4: return " Friday"
        case 5: return  " Saturday"
        case 6: return " Sunday"
        default: return  "Monday"
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


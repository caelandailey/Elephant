//
//  TableViewController.swift
//  Elephant
//
//  Created by Caelan Dailey on 2/20/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//
// TABLE FOR EVENT TABLE
// A scrolling list that shows each event
// an event has a name, time, and day
// Can delete events
//

import Foundation
import UIKit

class EventTableViewController: UITableViewController, EventDatasetDelegate {
    
    private static var cellReuseIdentifier = "EventTableViewController.DatasetItemsCellIdentifier"
    
    let delegateID: String = UIDevice.current.identifierForVendor!.uuidString
    
    // Need to update on mainthread
    func datasetUpdated() {
        DispatchQueue.main.async(){
            self.tableView.reloadData()
            self.tableView.setNeedsDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventDataset.registerDelegate(self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: EventTableViewController.cellReuseIdentifier)
        self.title = "EVENTS"
        // Refresh button to reload data
        self.navigationItem.leftBarButtonItem = refreshListButton
    }
    
    @objc func updateTable(sender: UIButton) {
        datasetUpdated()
    }
    
    // Gets number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView == self.tableView, section == 0 else {
            return 0
        }
        
        return EventDataset.count
    }
    
    // Allows editing
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // KNOWN ISSUE: Crashing on deleting event
    // Attempt to fix because the error seems to happen if entry is deleted after the tableview updates
    // Attempt to fix didnt' work. Must be naother issue
    // Error message and internet not helpful :/
    // Same code in alarm table view but doesnt work correctly
    // ISSUE: UNKNOWN
    override func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // If deleting
        if (editingStyle == .delete) {

            // Create group
            let group = DispatchGroup()
            group.enter()
            
            DispatchQueue.main.async {
                EventDataset.deleteEntry(atIndex: indexPath.row)
               
                group.leave()
            }
            
            // Tell main thread group is done
            group.notify(queue: .main) {
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .middle)
                tableView.endUpdates()
            }
            
          
        }
    }
    
    // Refresh button for table data
    lazy var refreshListButton : UIBarButtonItem = {
        let refreshListButton = UIBarButtonItem()
        refreshListButton.image = UIImage(named: "refresh_icon")
        refreshListButton.action = #selector(updateTable)
        refreshListButton.target = self
        refreshListButton.style = .plain
        return refreshListButton
    }()
    
    // THIS POPULATES CELLS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView === self.tableView, indexPath.section == 0, indexPath.row < EventDataset.count else {
            return UITableViewCell()
        }
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: EventTableViewController.cellReuseIdentifier, for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: EventTableViewController.cellReuseIdentifier)
        }
        // Get object for row
        let entry = EventDataset.entry(atIndex: indexPath.row)
        cell.textLabel?.text = entry.name
        
        // Calculates time
        let hour: Int = Int(entry.time/3600)
        let minute: Int = (Int(entry.time) - (hour)*3600) / 60
        var minuteString = String(minute)
        if (minute < 10) {
            minuteString = "0\(minute)"
        }
        let dayString = entry.day
        
       // Set labels
        cell.detailTextLabel?.text = dayString + " \(hour):" + minuteString
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true

        return cell
    }
}

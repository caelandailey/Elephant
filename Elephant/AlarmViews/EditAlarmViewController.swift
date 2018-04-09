//
//  DetailViewController.swift
//  Elephant
//
//  Created by Caelan Dailey on 2/20/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//
// THIS CLASS also has a copy: NewAlarmViewController
// Easier to just copy them and have 2
// The EditAlarmView is created when an existing alarm is selected.
// Must fill view you current existing info
// The New Alarm View doesnt need to
//
//
import UIKit

class EditAlarmViewController: UIViewController, AlarmDatasetDelegate {
    
    private let index: Int
    
    // Custom delegate
    let delegateID: String = UIDevice.current.identifierForVendor!.uuidString
    
    private var alarmView: ViewHolder {
        return view as! ViewHolder
    }
    
    func datasetUpdated() {
        let entry = AlarmDataset.entry(atIndex: index)
        alarmView.alarmName = entry.name
        alarmView.alarmTime = entry.time
        alarmView.alarmDuration = entry.duration
        alarmView.currentDays = entry.days
        alarmView.currentRepeater = entry.repeater
        alarmView.currentZone = entry.zone
    }
    
    init(withIndex: Int) {
        index = withIndex
        super.init(nibName: nil, bundle: nil)
        AlarmDataset.registerDelegate(self)
        // MAKES IT SO IT DOESNT GO UNDER TAB BARS or NAVIGATION BARS
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ViewHolder()
        print("Detail view load")
    }
    override func viewDidLoad() {
        datasetUpdated()
    }
    
    // We left the edit view so save everything that we edited!!
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("edit alarm viewDidDisappear")
        
        let entry = AlarmDataset.Entry(
            name: alarmView.alarmName,
            days: alarmView.currentDays,
            repeater: alarmView.currentRepeater,
            zone: alarmView.currentZone,
            duration: alarmView.alarmDuration,
            time: alarmView.alarmTime
        )
        AlarmDataset.editEntry(atIndex: index, newEntry: entry)
    }
}

//
//  DetailViewController.swift
//  Elephant
//
//  Created by Caelan Dailey on 2/20/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import UIKit

class NewAlarmViewController: UIViewController, AlarmDatasetDelegate {
    
    let delegateID: String = UIDevice.current.identifierForVendor!.uuidString
    
    private var alarmView: ViewHolder {
        return view as! ViewHolder
    }
    
    // DOnt need
    func datasetUpdated() {}
    
    init() {
        super.init(nibName: nil, bundle: nil)
        AlarmDataset.registerDelegate(self)
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ViewHolder()
        view.backgroundColor = .white
        print("Detail view load")
    }
    override func viewDidLoad() {
        datasetUpdated()
    }
    
    // Left view so create a new alarm
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("new alarm viewDidDisappear")
        
        let entry = AlarmDataset.Entry(
            name: alarmView.alarmName,
            days: alarmView.currentDays,
            repeater: alarmView.currentRepeater,
            zone: alarmView.currentZone,
            duration: alarmView.alarmDuration,
            time: alarmView.alarmTime
        )
        print("below")
        print(alarmView.alarmDuration)
        AlarmDataset.appendEntry(entry)
    }
}

//
//  Dataset.swift
//  Elephant
//
//  Created by Caelan Dailey on 2/20/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//
// A class to handle event objects for the EventTable
// An entry has a name, day, time

import Foundation

// Must conform to delegate
protocol EventDatasetDelegate: class {
    var delegateID: String { get}
    func datasetUpdated()
}

// Create event
final class EventDataset {
    final class Entry {
        let name: String
        let day: String
        let time: TimeInterval
        
        init(name: String, day: String, time: TimeInterval) {
            self.name = name
            self.day = day
            self.time = time
        }
    }

    // Setup delegate
    private final class WeakDatasetDelegate {
        weak var delegate: EventDatasetDelegate?
        
        init(delegate: EventDatasetDelegate) {
            self.delegate = delegate
        }
    }
    
    // Objects
    private static var entries: [Entry] = []
    private static var entriesLock: NSLock = NSLock()
    private static var delegates: [String: WeakDatasetDelegate] = [:]
    private static var delegatesLock: NSLock = NSLock()
    
    // Keep track of count. usefull for tableview
    static var count: Int {
        var count: Int = 0
        
        entriesLock.lock()
        count = entries.count
        entriesLock.unlock()
        
        return count
    }
    
    // Gets an entry object
    static func entry(atIndex index: Int) -> Entry {
        var entry: Entry?
        
        entriesLock.lock()
        entry = entries[index]
        entriesLock.unlock()
        return entry!
    }
    
    // Add to entries list
    static func appendEntry(_ entry: Entry) {
        print("WROTE TO EVENTDATASET")
        entriesLock.lock()
        entries.append(entry)
        entriesLock.unlock()
        
        delegatesLock.lock()
        delegates.values.forEach({ (weakDelegate: WeakDatasetDelegate) in
            weakDelegate.delegate?.datasetUpdated()
        })
        delegatesLock.unlock()
        
    }
    
    // Delete an entry when deleteing in table
    static func deleteEntry(atIndex index: Int) {
        entriesLock.lock()
        entries.remove(at: index)
        entriesLock.unlock()
        
        delegatesLock.lock()
        delegates.values.forEach({ (weakDelegate: WeakDatasetDelegate) in
            weakDelegate.delegate?.datasetUpdated()
        })
        delegatesLock.unlock()
    }
    
    // When loading data, delete all current entries
    static func deleteAll(){
        entriesLock.lock()
        entries.removeAll()
        entriesLock.unlock()
    }
    
    // Controls delegates
    static func registerDelegate(_ delegate: EventDatasetDelegate) {
        
        delegatesLock.lock()
        delegates[delegate.delegateID] = WeakDatasetDelegate(delegate: delegate)
        delegatesLock.unlock()
    }
}


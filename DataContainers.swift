//
//  DataContainers.swift
//  TimeTrack
//
//  Created by Daniel Rasmussen on 2/2/22.
//

import Foundation

// A container to hold the amount of minutes
// on shift during a given day.
class Shift {
    var id = UUID()
    var startTime : String
    var endTime : String
    var date : String
    
    // Initialize the shift's clock in and clock out times.
    init(startTime : String, endTime : String, date : String) {
        // Initialize the object's variables.
        self.startTime = startTime
        self.endTime = endTime
        self.date = date
    }
    
    // Allows the user to change the clock in time.
    func changeStartTime(startTime : String) {
        // TODO Error check the time
        self.startTime = startTime
    }
    
    // Allows the user to change the clock out time.
    func changeEndTime(endTime : String) {
        // TODO Error check the time
        self.endTime = endTime
    }
}

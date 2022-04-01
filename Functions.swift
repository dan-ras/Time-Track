//
//  Functions.swift
//  TimeTrack
//
//  Created by Daniel Rasmussen on 2/5/22.
//

import Foundation

/// GLOBAL VARIABLES

// Get the user's calendar, gregorian probably.
let userCalendar = Calendar.current

//// Helpers:
//let key = "shift"
//let defaults = UserDefaults.standard


// Containers for Daily, Weekly, and Pay Period shifts.
var dShifts : [Shift] = []
var wShifts : [Shift] = []
var pShifts : [Shift] = []
//var shifts : [Shift] = checkDefaults()
//
//func checkDefaults() -> Array<Shift> {
//    if UserDefaults.standard.object(forKey: key) != nil {
//        return UserDefaults.standard.object(forKey: key) as? [Shift] ?? [Shift]()
//    } else {
//        print("run")
//        return []
//    }
//}


var shifts : [Shift] = []

// Create a formatter to convert date
// objects into strings.
let formatter = DateFormatter()


/// APP FUNCTIONS

/// Allows the user to clock in.
///
/// Parameters: Optional start time. Hardcoded to be either
///          "00:00" if the function is called by clockOut(),
///          otherwise the value is nil.
/// Return Value: None
func clockIn(sTime : String?) -> Void {
    // Create and store the current date and time
    let date = Date()
    
    // Error checking...
    formatter.timeStyle = .short
    formatter.dateStyle = .short
    print("--------------")
    print("Shift Start: \(formatter.string(from: date))")

    // Stle the format of the string
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    let startTime = formatter.string(from: date)
    
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    let startDate = formatter.string(from: date)
    
    // Needs to be var because of the edit functionality in the Pay Period view.
    var shift = Shift(startTime: sTime ?? startTime, endTime: "?", date: startDate)
    shifts.append(shift)
}

/// Allows the user to clock out.
///
/// Parameters: None
/// Return Value: None
func clockOut() -> Void {
    // Check for a shift to clockout of.
    if shifts.isEmpty {
        print("Error: No shifts in day list.")
        return
    }
    
    // Create and store the current date and time
    let date = Date()
    
    // Error checking...
    formatter.timeStyle = .short
    formatter.dateStyle = .short
    print("Shift End: \(formatter.string(from: date))")
    print("--------------")

    // Stle the format of the string
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    let endTime = formatter.string(from: date)
    
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    let endDate = formatter.string(from: date)
    
    // If the user clocks out after midnight (00:00 AM),
    // end yesterday's shift, create a new shift with
    // start time of midnight, then give the new shift
    // an end time.
    if (shifts.last?.date == endDate) {
        shifts.last?.endTime = endTime
    } else {
        shifts.last?.endTime = "11:59 PM"
        clockIn(sTime: "00:00 AM")
        shifts.last?.endTime = endTime
    }
}

/// Get the Clocked in status to display on the home screen.
///
/// Parameters: Clock status of user (in or out).
/// Return Value: A String to be used in a text field
func getStatus(status : Bool) -> String {
    if status {
        return "Clocked In"
    } else {
        return "Clocked Out"
    }
}

/// Get the clock status, except return a Bool.
///
/// Parameters: None
/// Return Value: A bool to be used as a @State variable.
func getClockStatus() -> Bool {
    // Check to see if the user has clocked in yet.
    if dShifts.isEmpty {
        return false
    } else {
        return (dShifts.last?.startTime != nil && dShifts.last?.endTime == "?")
    }
}

// Clear the Day shift array
func clearShifts() -> Void {
    print("Shifts: \(shifts)")
    shifts.removeAll()
    print("Shifts: \(shifts)")
}

/// Submit the hours to the employer
///
/// Parameters: None
/// Return Value: None
func submitHours() -> Void {
    
}

/// Calculate how much money has been made during the week.
///
/// Parameters: None
/// Return Value: String containing a dollar amount.
func calcWeekIncome() -> String {
    // Check to see if a wage is set in user defaults.
//    let wage = UserDefaults.standard.integer(forKey: "userWage")
    let wage : Double = 20.75 // Remove eventually
    if (wage == 0) {
        return "0.00"
    }
    
    // Get the time worked for the week
    let time = computeWeeklyT()
    
    // Split the string returned by computeWeeklyT() into hours and minutes,
    // store in an array.
    let timeComponents = time.split(separator: ":")
    
    // Strip whitespace and convert the time from String to Double
    // Convert the minutes to a precentage of hourly by dividing by 60.
    let hours   = (Double(timeComponents[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0)
    let minutes = (Double(timeComponents[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0) / 60
    
    // Calculate the money made.
    let money = (hours + minutes) * wage
    // Round to the nearest hundredth
    let roundMoney = round(money * 100) / 100.0
    
    // Convert result to a string and return.
    let check = String(roundMoney).split(separator: ".")
    
    // Add a zero to keep display consistency, i.e. $4.5 -> $4.50
    if (check[1].count == 1) {
        return String(roundMoney) + "0"
    } else {
        return String(roundMoney)
    }
}

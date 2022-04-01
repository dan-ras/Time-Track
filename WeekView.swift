//
//  WeekView.swift
//  TimeTrack
//
//  Created by Daniel Rasmussen on 1/15/22.
//

import SwiftUI

struct WeekView: View {
    @State var time : String = "00:00"
    @State var weekMoney : String = "0.00"
    let timer = Timer.publish(every: 60.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HeaderView()
            VStack {
                ///**************************************
                /// Display the time worked in the current week.
                ///**************************************
                Text("Weekly Time:")
                    .font(Font.system(size: 20))
                    .padding(.top)
                Text(time)
                    .font(Font.system(size: 75))
                    .onReceive(timer) { _ in
                        if !shifts.isEmpty {
                            time = computeWeeklyT()
                        }
                    }
                    .onAppear(perform: {
                        time = computeWeeklyT()
                    })
                
                ///**************************************
                /// Display the money made during the week.
                ///
                /// WAGE x HOURS = INCOME.
                ///**************************************
                Text("Weekly Income:")
                    .font(Font.system(size: 20))
                    .padding(.top)
                Text("$" + weekMoney)
                    .font(Font.system(size: 75))
                    .font(Font.largeTitle)
                    .onReceive(timer) { _ in
                        if !shifts.isEmpty {
                            weekMoney = calcWeekIncome()
                        }
                    }
                    .onAppear(perform: {
                        weekMoney = calcWeekIncome()
                    })
            }
            .foregroundColor(Color.white)

            Spacer()
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView()
    }
}

/// Computes the time worked each week.
///
/// Parameters: None
/// Return value: The time worked each week as a string.
func computeWeeklyT() -> String {
    // Check to see if the user has clocked in yet.
    if shifts.isEmpty {
        print(shifts)
        return "00 : 00"
    }
    else {
        // Clear the wShifts array to prevent duplicates.
        wShifts.removeAll()
        
        // Convert date and time strings back to date() object
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        // Iterate through the shifts array and grab all shifts
        // that have a date before the next saturday.
        for shift in shifts {
            let dateString = (shift.date ) + ", " + (shift.startTime )
            guard let shiftDate = formatter.date(from: dateString) else { return "0" }
            
            // TODO in the day tie locked state to shifts
            
            
            // FIX this logic
            if (Calendar.current.component(.weekday, from: shiftDate) <= 6) {
                wShifts.append(shift)
            } else {
                break
            }
        }
        // Iterate through the weekly shifts and tally all of the seconds of the shifts.
        // Store the number of seconds in a variable as an int.
        var weekHours   : Int = 0
        var weekMinutes : Int = 0
        for shift in wShifts {
            let startDateString = shift.date + ", " + shift.startTime
            guard let startDate = formatter.date(from: startDateString) else { return "Week" }
            // Get the shift's ending time:
            if shift.endTime == "?" {
                let endDate = Date()
                let shiftTime = userCalendar.dateComponents(
                    [.hour, .minute],
                    from: startDate,
                    to: endDate
                  )
                weekHours += shiftTime.hour!
                weekMinutes += shiftTime.minute!
            } else {
                let endDateString = shift.date + ", " + shift.endTime
                guard let endDate = formatter.date(from: endDateString) else { return "Week1" }
                let shiftTime = userCalendar.dateComponents(
                    [.hour, .minute],
                    from: startDate,
                    to: endDate
                  )
                weekHours += shiftTime.hour!
                weekMinutes += shiftTime.minute!
            }
        }
        // Format the return string to ensure display consistency...
        // Hours:
        var hours : String
        if (weekHours < 10) {
            hours = "0" + String(weekHours)
        } else {
            hours = String(weekHours)
        }
        // Minutes:
        var minutes : String
        if (weekMinutes < 10) {
            minutes = "0" + String(weekMinutes)
        } else {
            minutes = String(weekMinutes)
        }
        // Return the minutes and hours.
        return hours + " : " + minutes
    }
}

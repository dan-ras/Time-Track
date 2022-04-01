//
//  DayView.swift
//  TimeTrack
//
//  Created by Daniel Rasmussen on 1/15/22.
//

import SwiftUI

// Day View:
//
// Code for the day view, this is also the app's default view.
struct DayView: View {
    @Binding var clockedIn : Bool
    @State var time : String = "00:00"
    let timer = Timer.publish(every: 30.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HeaderView()
            
            VStack {
                ///**************************************
                /// Display the clocked status. (in or out)
                ///**************************************
                HStack {
                    Text("Status: ")
                        .bold()
                    if clockedIn {
                        Text(getStatus(status: clockedIn))
                            .bold()
                            .foregroundColor(Color.green)
                    } else { 
                        Text(getStatus(status: clockedIn))
                            .bold()
                            .foregroundColor(Color.red)
                    }
                }
                .font(Font.system(size: 25))
                .foregroundColor(Color.white)
                
                ///**************************************
                /// Display the time worked on the current day.
                ///**************************************
                VStack {
                    // Display time worked today.
                    Text("Daily Time:")
                        .font(Font.system(size: 20))
                        .padding(.top)
                    Text(time)
                        .font(Font.system(size: 75))
                        .font(Font.largeTitle)
                        .onReceive(timer) { _ in
                            if !shifts.isEmpty && clockedIn {
                                time = computeDailyT()
                            }
                        }
                        .onAppear(perform: {
                            time = computeDailyT()
                        })
                }
                .foregroundColor(Color.white)

                Spacer() // Do not remove.
            }
            
            ///**************************************
            /// Display the clock in and out buttons based on
            /// clocked status.
            ///**************************************
            VStack {
                // If we are clocked out we show the clock in button.
                if !self.clockedIn {
                    Button(action:{
                        withAnimation(Animation.easeIn(duration: 0.1)){self.clockedIn.toggle()}; clockIn(sTime: nil)}){
                        Text("Clock In")
                            .font(Font.title)
                            .bold()
                            .frame(width: 200.0, height: 200.0)
                            .foregroundColor(Color.white)
                        }
                        .background(Circle().fill(Color.thisBlue))
                        .padding()
                } else {
                    Button(action:{
                        withAnimation(Animation.easeIn(duration: 0.1)){self.clockedIn.toggle()}; clockOut()}){
                            Text("Clock Out")
                                .font(Font.title)
                                .bold()
                                .frame(width: 200.0, height: 200.0)
                                .foregroundColor(Color.black)
                            }
                        .background(Circle().fill(Color.thisOrange))
                        .padding()
                }
            } .padding(50)
        }
    }
}

struct Views_Previews: PreviewProvider {
    static var previews: some View {
        DayView(clockedIn: .constant(false))
    }
}

/// Computes the time worked each day.
///
/// Parameters: None
/// Return value: The time worked each day as a string.
func computeDailyT() -> String {
    // Check to see if the user has clocked in yet.
    if shifts.isEmpty {
        return ("00 : 00")
    }
    else {
        // Clear the dShifts array to prevent duplicates.
        dShifts.removeAll()
        
        // Convert date and time strings back to date() object
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        // Iterate through the shifts array and grab all shifts
        // that have today's date.
        for shift in shifts {
            let dateString = shift.date + ", " + shift.startTime
            guard let shiftDate = formatter.date(from: dateString) else { return "Line 112" }
            
            // If the date of the shift matches the current date add the shift to
            // the dayShift array.
            formatter.timeStyle = .none // Don't use the time for the date comparison.
            if ((formatter.string(from: shiftDate)) == (formatter.string(from: Date()))) {
                dShifts.append(shift)
            } else {
                break
            }
            formatter.timeStyle = .short // I hate these formatters.
        }
        // Create variables to store the amount of time worked on a given day.
        var dayHours   : Int = 0
        var dayMinutes : Int = 0
        // Iterate through the weekly shifts and tally all of the seconds of the shifts.
        for shift in dShifts {
            let startDateString = shift.date + ", " + shift.startTime
            guard let startDate = formatter.date(from: startDateString) else { return "Line 139" }
            // Get the shift's ending time:
            if shift.endTime == "?" {
                let endDate = Date()
                let shiftTime = userCalendar.dateComponents(
                    [.hour, .minute, .second],
                    from: startDate,
                    to: endDate
                  )
                dayHours += shiftTime.hour!
                dayMinutes += shiftTime.minute!
            } else {
                let endDateString = shift.date + ", " + shift.endTime
                guard let endDate = formatter.date(from: endDateString) else { return "Line 145" }
                let shiftTime = userCalendar.dateComponents(
                    [.hour, .minute, .second],
                    from: startDate,
                    to: endDate
                  )
                dayHours += shiftTime.hour!
                dayMinutes += shiftTime.minute!
            }
        }
        // Format the return string to ensure display consistency...
        // Hours:
        var hours : String
        if (dayHours < 10) {
            hours = "0" + String(dayHours)
        } else {
            hours = String(dayHours)
        }
        // Minutes:
        var minutes : String
        if (dayMinutes < 10) {
            minutes = "0" + String(dayMinutes)
        } else {
            minutes = String(dayMinutes)
        }
        // Return the minutes and hours.
        return hours + " : " + minutes
    }
}

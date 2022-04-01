//
//  PeriodView.swift
//  TimeTrack
//
//  Created by Daniel Rasmussen on 2/23/22.
//
// 

import SwiftUI

struct PeriodView: View {
    @Binding var selectedTab : Int
    @State var time : String = "00:00"
    @State var showDayHours : Bool = false
    let timer = Timer.publish(every: 60.0, on: .main, in: .common).autoconnect()
    
    // Created for UI layout.
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    // The Pay Period View...
    var body: some View {
        VStack {
            HeaderView()
            VStack {
                // Display time worked this week.
                Text("Pay Period Time:")
                    .font(Font.system(size: 20))
                    .padding(.top)
                Text(time)
                    .font(Font.system(size: 75))
                    .onReceive(timer) { _ in
                        if !shifts.isEmpty {
                            time = computePayPeriodT()
                        }
                    }
                    .onAppear(perform: {
                        time = computePayPeriodT()
                    })
            }

            Spacer()
            
            // Create a two week Calender of shifts worked in the past to weeks.
            // Week 01
            LazyVGrid(columns: columns, alignment: .leading, content: {
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("S")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("M")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("T")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("W")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("Th")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("F")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("S")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
            })
            
            // Week 02
            LazyVGrid(columns: columns, alignment: .leading, content: {
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("S")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("M")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("T")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("W")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("Th")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("F")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
                
                Button(action: { withAnimation { self.showDayHours.toggle()}} ) {
                    Text("S")
                        .bold()
                        .frame(width: 75.0, height: 75.0)
                }.padding()
            })
            
            Spacer()
            
            // Show the submit hours button.
            Button(action: {
                submitHours();
                selectedTab = 0;
            }) {
                Text("Submit Hours")
                    .bold()
                    .padding()
                    .background(Color.thisBlue)
                    .cornerRadius(25)
            }
            .padding(.bottom, 50)
        }
        .foregroundColor(Color.white)

    }
}

struct PeriodView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodView(selectedTab: .constant(2))
    }
}

/// Computes the time worked each pay period.
///
/// Parameters:
/// Return value:
func computePayPeriodT() -> String {
    // Check to see if the user has clocked in yet.
    if shifts.isEmpty {
        return "00 : 00"
    }
    else {
        // Clear the wShifts array to prevent duplicates.
        pShifts.removeAll()
        
        // Convert date and time strings back to date() object
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        // Iterate through the shifts array and grab all shifts
        // that have a date before the next saturday.
        for shift in shifts {
            let dateString = (shift.date ) + ", " + (shift.startTime )
            guard let shiftDate = formatter.date(from: dateString) else { return "" }
            if (Calendar.current.component(.weekday, from: shiftDate) < 6) {
                
                // FIX this
                pShifts.append(shift)
            } else {
                break
            }
        }
        // Iterate through the weekly shifts and tally all of the seconds of the shifts.
        // Store the number of seconds in a variable as an int.
        var periodHours   : Int = 0
        var periodMinutes : Int = 0
        for shift in pShifts {
            let startDateString = (shift.date ) + ", " + (shift.startTime )
            guard let startDate = formatter.date(from: startDateString) else { return "Week" }
            // Get the shift's ending time:
            if shift.endTime == "?" {
                let endDate = Date()
                let shiftTime = userCalendar.dateComponents(
                    [.hour, .minute],
                    from: startDate,
                    to: endDate
                  )
                periodHours += shiftTime.hour!
                periodMinutes += shiftTime.minute!
            } else {
                let endDateString = (shift.date ) + ", " + (shift.endTime )
                guard let endDate = formatter.date(from: endDateString) else { return "Week1" }
                let shiftTime = userCalendar.dateComponents(
                    [.hour, .minute],
                    from: startDate,
                    to: endDate
                  )
                periodHours += shiftTime.hour!
                periodMinutes += shiftTime.minute!
            }
        }
        // Format the return string to ensure display consistency...
        // Hours:
        var hours : String
        if (periodHours < 10) {
            hours = "0" + String(periodHours)
        } else {
            hours = String(periodHours)
        }
        // Minutes:
        var minutes : String
        if (periodMinutes < 10) {
            minutes = "0" + String(periodMinutes)
        } else {
            minutes = String(periodMinutes)
        }
        // Return the minutes and hours.
        return hours + " : " + minutes
    }
}

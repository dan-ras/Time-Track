//
//  SettingsView.swift
//  TimeTrack
//
//  Created by Daniel Rasmussen on 2/23/22.
//

import SwiftUI

struct Settings: View {
    let numFormatter: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .decimal
          return formatter
    }()
    
    // View variables
    @State var employerNum : String = ""
    @State var employeeWage : Double = 20.75
    
    var body: some View {
        VStack {
            ///**************************************
            /// Employer phone number input.
            ///**************************************
            Text("Employer Phone Number:")
                .font(Font.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.leading)
                .padding(.top)
            
            TextField("(555) 555-5555", text: $employerNum)
                .onSubmit { /* Save phone number to user defaults */ }
                .keyboardType(.numberPad)
                .padding()
                .background(Color.lightGray)
                .cornerRadius(25.0)
                .padding()
            
            ///**************************************
            /// Employee wage input.
            ///**************************************
            Text("Employee Hourly Wage:")
                .font(Font.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.leading)
            TextField("Hourly wage", value: $employeeWage, formatter: numFormatter)
                .onSubmit { /* Save phone number to user defaults */ }
                .keyboardType(.numberPad)
                .padding()
                .background(Color.lightGray)
                .cornerRadius(25.0)
                .padding()
            
            Spacer()
            
            ///**************************************
            /// Clears shifts, remove in final build.
            ///**************************************
            Button(action: {
                clearShifts()
            }) {
                HStack {
                    Text("Clear Shift History")
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 23.0, height: 23.0)
                }
                .padding()
                .background(Color.thisBlue)
                .cornerRadius(25)
            }

            Spacer()
        }
        .background(Color.darkGray)
        .foregroundColor(Color.white)
        .navigationTitle("Settings")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

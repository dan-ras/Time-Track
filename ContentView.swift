//
//  ContentView.swift
//  TimeTrack
//
//  Created by Daniel Rasmussen on 1/15/22.
//
//  Weekly hour counter: 

import SwiftUI

// Define the custom colors used in the application's UI.
extension Color {
    static let darkGray   = Color(red: 22 / 255, green: 22 / 255, blue: 22 / 255)
    static let lightGray  = Color(red: 33 / 255, green: 33 / 255, blue: 33 / 255)
    static let thisBlue   = Color(red: 53 / 255, green: 92 / 255, blue: 105 / 255)
    static let thisOrange = Color(red: 255 / 255, green: 150 / 255, blue: 79 / 255)
}

// Main Content View structure:
struct ContentView: View {
    // UI toggle variables:
    @State var clockedIn = false
    @State var selectedTab = 0

    // View logic
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                DayView(clockedIn: $clockedIn)
                    .tabItem {
                        Image(systemName: "sun.max")
                        Text("Daily")
                    }
                    .background(Color.darkGray)
                    .tag(0)
                WeekView()
                    .tabItem {
                        Image(systemName: "w.square")
                        Text("Weekly")
                    }
                    .background(Color.darkGray)
                    .tag(1)
                PeriodView(selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Pay Period")
                    }
                    .background(Color.darkGray)
                    .tag(2)
            }
            .onAppear() {
                UITabBar.appearance().backgroundColor = .black
                UITabBar.appearance().unselectedItemTintColor = .white
            }
            .accentColor(Color.thisBlue)
            .navigationTitle("")
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
        
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



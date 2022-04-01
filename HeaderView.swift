//
//  HeaderView.swift
//  TimeTrack
//
//  Created by Daniel Rasmussen on 2/23/22.
//

import SwiftUI

/// Contains the code for the top of the view, consisting of
/// the date and the menu button.
struct HeaderView: View {
    var body: some View {
        ///**************************************
        /// Display both the current date and the menu button.
        ///**************************************
        HStack {
            Text(getHeaderDate())
                .bold()
                .font(Font.body)
                .padding()
            Spacer()
            NavigationLink(destination: Settings()) {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .frame(width: 40.0, height: 35.0)
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .padding()
        }
        .foregroundColor(Color.white)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}

/// Gets the current date for the default view.
///
/// Parameters: None
/// Return value: Current date and time as a String
func getHeaderDate() -> String {
    // Get the current date
    let date = Date()
    formatter.timeStyle = .none
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}

//
//  WelcomePopup.swift
//  PaperNote
//
//  Created by Morris Richman on 4/27/24.
//

import SwiftUI

struct WelcomePopup: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Image("AppIconMac")
                .resizable()
                .scaledToFit()
                .padding()
                .frame(maxHeight: 200)
            Text("Welcome to PaperNote")
                .font(.largeTitle)
                .bold()
            Text("A running note that is just like paper.")
            Spacer()
            
            Button(action: dismiss.callAsFunction) {
                Text("Let's Go")
                    .padding()
                    .foregroundStyle(Color.white)
                    .background(RoundedRectangle(cornerRadius: 12.5).fill(Color.accentColor))
            }
            .frame(width: 250)
        }
        .padding()
    }
}

#Preview {
    WelcomePopup()
}

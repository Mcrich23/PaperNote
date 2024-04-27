//
//  ContentView.swift
//  PaperNote
//
//  Created by Morris Richman on 4/27/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("note") var note = ""
    @AppStorage("welcomePopup") var welcomePopup = true
    var body: some View {
        VStack {
            HStack {
                Text("PaperNote")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button {
                    welcomePopup = true
                } label: {
                    Image(systemName: "newspaper.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                }
            }
            TextEditor(text: $note)
                .overlay(alignment: .topLeading) {
                    if note.isEmpty {
                        Text("Type Something....")
                            .padding(.top, 8)
                            .padding(.leading, 3)
                            .foregroundStyle(Color.secondary)
                    }
                }
        }
        .padding()
        .sheet(isPresented: $welcomePopup, content: {
            WelcomePopup()
        })
    }
}

#Preview {
    ContentView()
}

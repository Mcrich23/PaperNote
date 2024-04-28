//
//  ContentView.swift
//  PaperNote
//
//  Created by Morris Richman on 4/27/24.
//

import SwiftUI
import RichTextKit

struct ContentView: View {
    @State private var note: NSAttributedString
    @AppStorage("welcomePopup") private var welcomePopup = true
    private let richTextContext = RichTextContext()
    
    init() {
        self._note = State(wrappedValue: ContentView.getNote() ?? NSAttributedString())
    }
    @FocusState var isTextEditorFocused
    
    var textEditorTopCornerRadius: CGFloat {
        12.5
    }
    
    var textEditorBottomCornerRadius: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return isTextEditorFocused ? 12.5 : 50
        } else {
            return 12.5
        }
    }
    
    var veryBottomPadding: CGFloat {
        if #available(iOS 17.0, *) {
            if UIDevice.current.userInterfaceIdiom == .vision {
                return isTextEditorFocused ? 0 : -20
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return isTextEditorFocused ? 0 : -45
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            return isTextEditorFocused ? 0 : -20
        } else {
            return isTextEditorFocused ? 0 : 3
        }
    }
    
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

            RichTextEditor(text: $note, context: richTextContext)
                .overlay(alignment: .topLeading) {
                    if note.string.isEmpty {
                        Text("Type Something....")
                            .padding(.top, 8)
                            .padding(.leading, 3)
                            .foregroundStyle(Color.secondary)
                    }
                }
                .padding(5)
                .clipShape(
                    UnevenRoundedRectangle(topLeadingRadius: textEditorTopCornerRadius, bottomLeadingRadius: textEditorBottomCornerRadius, bottomTrailingRadius: textEditorBottomCornerRadius, topTrailingRadius: textEditorTopCornerRadius)
//                        .fill(Color(uiColor: .systemBackground))
                )
                .background(
                    UnevenRoundedRectangle(topLeadingRadius: textEditorTopCornerRadius, bottomLeadingRadius: textEditorBottomCornerRadius, bottomTrailingRadius: textEditorBottomCornerRadius, topTrailingRadius: textEditorTopCornerRadius)
                        .fill(Color(uiColor: .systemBackground))
                        .shadow(radius: 10)
                )
                .focused($isTextEditorFocused)
            RichTextKeyboardToolbar(context: richTextContext, leadingButtons: { _ in
                if UIDevice.current.userInterfaceIdiom == .phone {
                    HStack(spacing: 6) {
                        Button("", systemImage: "bold") {
                            richTextContext.toggleStyle(.bold)
                        }
                        .foregroundStyle(Color.primary)
                        Button("", systemImage: "italic") {
                            richTextContext.toggleStyle(.italic)
                        }
                        .foregroundStyle(Color.primary)
                        Button("", systemImage: "underline") {
                            richTextContext.toggleStyle(.underlined)
                        }
                        .foregroundStyle(Color.primary)
                        Button("", systemImage: "strikethrough") {
                            richTextContext.toggleStyle(.strikethrough)
                        }
                        .foregroundStyle(Color.primary)
                    }
                }
            }, trailingButtons: { $0 }, formatSheet: { $0.foregroundStyle(Color.primary) })
        }
        .padding()
        .sheet(isPresented: $welcomePopup, content: {
            WelcomePopup()
        })
        .onChange(of: note, perform: { _ in
            saveNote()
        })
        .padding(.bottom, veryBottomPadding)
    }
    
    static private func getNote() -> NSAttributedString? {
        guard let data = UserDefaults.standard.data(forKey: "attributedNoteData") else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let attributedNote = try decoder.decode(AttributedString.self, from: data)
            return NSAttributedString(attributedNote)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func saveNote() {
        guard !note.string.isEmpty else { return }
        
        do {
            let attributedNote = AttributedString(self.note)
            let encoder = JSONEncoder()
            let attributedNoteData = try encoder.encode(attributedNote)
            UserDefaults.standard.setValue(attributedNoteData, forKey: "attributedNoteData")
        } catch {
            print(error)
        }
    }
}

#Preview {
    ContentView()
}

//
//  RageTextInput.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI
import SwiftUIX

struct RageTextInput: View {
    @EnvironmentObject var state: AppState
    @State private var opacity = 1.0

    var body: some View {
        GeometryReader { geometry in
                Path() { path in
                    path.move(to: CGPoint(x: 0, y: state.defaultFontSize * 1.5))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: state.defaultFontSize * 1.5))
                }
                .stroke(.white, lineWidth: 1)
                .opacity(0.1)

                HStack {
                    Text(state.attributedString)
                        .font(.system(size: state.defaultFontSize))
                        .truncationMode(.head)
                        .lineLimit(1)
                        .foregroundColor(.gray)
                        .frame(width: geometry.size.width * state.ratioLeft, alignment: .trailing)
                        .mask(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .leading, endPoint: .trailing))
                        .offset(x: -15)

                    Rectangle()
                        .fill(.white)
                        .frame(width: 15, height: state.defaultFontSize * 1.5)
                        .opacity(opacity)
                        .onAppear() {
                            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                                opacity = 0.2
                            }
                        }
                        .offset(x: -23)
                }

            // Autocomplete
            AutocompleteView()
                .visible(state.currentlySearching)
                .offset(x: geometry.size.width * state.ratioLeft)
            
            // Menu (WIP)
            HStack() {
                Button() {
                    self.save()
                } label: {
                    Text("Save")
                }

                Text(String(state.markdownFileNames.count) + " Indexed Markdown Files")
                    .font(.footnote)
            }
            .offset(y: geometry.size.height)

        }
    }
    
    func save() {
        let savePanel = NSSavePanel()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YY/MM/dd – HH:mm"
        let dateString = formatter.string(from: date)

        savePanel.allowedFileTypes = ["md"]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save your Streamline note"
        savePanel.message = "Choose a folder and a name"
        savePanel.prompt = "Save now"
        savePanel.nameFieldLabel = "File name:"
        savePanel.nameFieldStringValue = "Streamline Note " + dateString
        
        // Present the save panel as a modal window.
        let response = savePanel.runModal()
        guard response == .OK, let saveURL = savePanel.url else { return }
        try? state.allCharactersStorageStringArray.joined().write(to: saveURL, atomically: true, encoding: .utf8)
    }
}

struct RageTextInput_Previews: PreviewProvider {
    static var previews: some View {
        RageTextInput()
    }
}

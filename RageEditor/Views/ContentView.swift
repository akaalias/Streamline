//
//  ContentView.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var state: AppState
    @AppStorage("folderBookmarkData") private var folderBookmarkData: Data = Data()
    @StateObject var keyboardInput = KeyboardInput()
    @State private var monitor: Any?

    var body: some View {
        KeyboardEvent(into: $keyboardInput.keyCode)

        GeometryReader { geometry in
            if(folderBookmarkData.isEmpty) {
               FolderSetupView()
                .offset(x: geometry.size.width / 2.0 - 200,
                        y: (geometry.size.height / 2) - 200)
            } else {
                RageTextInputView()
                    .offset(y: (-geometry.size.height / state.ratioTop) + state.defaultFontSize)
            }
        }
        .padding(20)
        .onDisappear() {
            NSEvent.removeMonitor(self.monitor)
        }
        .onAppear() {
            state.setupCacheFromBookmark()
            self.monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
                state.handleKeyEvent(event: aEvent)
                return aEvent
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

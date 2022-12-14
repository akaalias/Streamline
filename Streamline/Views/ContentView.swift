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
    @AppStorage("showParticles") private var showParticles: Bool = false

    @StateObject var keyboardInput = KeyboardInput()
    @State private var monitor: Any?

    var body: some View {
        GeometryReader { geometry in
            KeyboardEvent(into: $keyboardInput.keyCode)
                .frame(width: 0, height: 0)
            
            ZStack {
                SpriteView(scene: state.scene, options: [.allowsTransparency])
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .opacity(0.5)
                
                if(state.showSettingsPanel) {
                    SettingsView()
                } else {
                    if(state.showWelcomeScreen) {
                        WelcomeView()
                    } else {
                        RageTextInputView()
                            .offset(y: (geometry.size.height / state.ratioTop) - state.defaultFontSize)
                    }
                }
            }
        }
        .onAppear() {
            self.monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
                let _ = state.handleKeyEvent(event: aEvent)

                if aEvent.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.command) {
                    return aEvent
                }

                return nil
            }
            state.setupCacheFromBookmark()
        }
        .onDisappear() {
            NSEvent.removeMonitor(self.monitor as Any)
        }
        .readSize { size in
            state.dynamicWindowSize = size
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

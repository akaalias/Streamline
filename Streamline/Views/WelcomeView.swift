//
//  DemoVideoView.swift
//  Streamline
//
//  Created by Alexis Rondeau on 27.11.22.
//

import SwiftUI
import AVKit

struct WelcomeView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.openURL) var openURL
        
    var body: some View {
        VStack(alignment: .center) {
            Text("Hello and welcome to Streamline, let's get you started!")
                .font(.title)
                .padding()

            Text("Before anything else, let's have some fun! Hit your DELETE and RETURN keys a few times. Nice.")
                .font(.title2)
                .padding()
            
            Divider()
                .padding()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Step 1")
                        .font(.title)

                    Text("If you're new to Streamline, fret not! Here is a quick demo video to get you started.")
                        .font(.title3)
                        .multilineTextAlignment(.leading)

                    Button {
                        openURL(URL(string: "https://getstreamline.app?wvideo=f1xos22k50")!)
                    } label: {
                        Text("Watch the Video")
                    }
                }
                .padding()
                .frame(width: 300)
                
                VStack(alignment: .leading) {
                    Text("Step 2")
                        .font(.title)

                    Text("Link at the speed of your consciousness – Set up your Obsidian vault folder for auto-complete.")
                        .font(.title3)
                        .multilineTextAlignment(.leading)

                    Button {
                        state.showSettingsPanel = true
                    } label: {
                        Text("Set up my vault")
                    }
                }
                .frame(width: 300)
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Step 3")
                        .font(.title)

                    Text("You're all set up. Step three is you start practicing for a few minutes of thinking out loud.")
                        .font(.title3)
                        .multilineTextAlignment(.leading)

                    Button {
                        state.showWelcomeScreen = false
                    } label: {
                        Text("I'm ready.")
                    }
                }
                .frame(width: 300)
                .padding()
                
            }
            
            Divider()
                .padding()

        }
    }
}

struct DemoVideoView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

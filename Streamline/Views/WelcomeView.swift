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

            Text("Before anything else, let's have some fun! Hit your DELETE key a few times. Nice.")
                .font(.title2)
                .padding()
            
            Divider()
                .padding()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Step 1")
                        .font(.title)
                        .padding()

                    Text("If you're new to Streamline, fret not! Here is a quick demo video to get you started.")
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                        .padding()

                    Button {
                        openURL(URL(string: "https://getstreamline.app?wvideo=f1xos22k50")!)
                    } label: {
                        Text("Watch the Video")
                    }
                    .padding()
                }
                .frame(width: 200)
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Step 2")
                        .font(.title)
                        .padding()

                    Text("Link at the speed of your consciousness – Set up your Obsidian vault folder for auto-complete.")
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                        .padding()

                    Button {
                        state.showSettingsPanel = true
                    } label: {
                        Text("Set up my vault")
                    }
                    .padding()
                }
                .frame(width: 200)
                .padding()
                
                VStack(alignment: .leading) {
                    
                    Text("Step 3")
                        .font(.title)
                        .padding()

                    Text("You're all set up. Step three is you start practicing for a few minutes of thinking out loud.")
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                        .padding()

                    Button {
                        state.showWelcomeScreen = false
                    } label: {
                        Text("I'm ready.")
                    }
                    .padding()

                }
                .frame(width: 200)
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

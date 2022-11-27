//
//  DemoVideoView.swift
//  Streamline
//
//  Created by Alexis Rondeau on 27.11.22.
//

import SwiftUI
import AVKit

struct DemoVideoView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack(alignment: .center) {
            Text("Hello and welcome to Streamline!")
                .font(.title)
                .padding(5)

            Text("If you're new to Streamline, fret not! Here is a quick demo video to get you started.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(5)

            Button {
                openURL(URL(string: "https://getstreamline.app?wvideo=f1xos22k50")!)
            } label: {
                Text("Watch the Streamline Demo Video")
            }
            .padding(5)
            .buttonStyle(.borderedProminent)
        
            Divider()

            Button {
                state.showDemoVideo = false
            } label: {
                Text("Got it! I'm ready.")
            }
            .padding(5)
        
            
            Text("If you need to, you can open this window later via the Help menu item.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(5)
        }
    }
}

struct DemoVideoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoVideoView()
    }
}

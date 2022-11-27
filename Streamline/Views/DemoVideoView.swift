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
    var player = AVPlayer(url: URL(string: "https://fast.wistia.net/embed/medias/f1xos22k50.m3u8")!)

    var body: some View {
        VStack {
            Text("Hello! Let's get you started with a quick demo:")
                .font(.title2)
                .padding(5)

            VideoPlayer(player: player)
                .frame(width: 815,
                       height: 510)
                .padding(5)
            
            Button {
                state.showDemoVideo = false
            } label: {
                Text("Got it! I'm ready.")
            }

        }
    }
}

struct DemoVideoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoVideoView()
    }
}

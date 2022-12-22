//
//  SettingsView.swift
//  Streamline
//
//  Created by Alexis Rondeau on 21.12.22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        ZStack {
            TabView {
                ObsidianVaultSettings()
                    .tabItem {
                        Label("Obsidian Vault", systemImage: "list.dash")
                    }

                AdvancedSettingsView()
                    .tabItem {
                        Label("Advanced", systemImage: "gear")
                    }
            }
            .frame(width: 600, height: 400)
            
            Button{
                state.showSettingsPanel.toggle()
            } label: {
                Label("", systemImage: "xmark.circle.fill")
                    .font(.title)
            }
            .buttonStyle(.plain)
            .offset(x: 300, y: -180)
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

//
//  SettingsPanelView.swift
//  Streamline
//
//  Created by Alexis Rondeau on 07.11.22.
//

import SwiftUI

struct SettingsPanelView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack {
            TabView {
                TutorialView()
                    .tabItem {
                        Label("Quick-Start Guide", systemImage: "book")
                        
                    }

                ObsidianVaultSettings()
                    .tabItem {
                        Label("Obsidian Linking", systemImage: "folder.badge.plus")
                    }   

                NotionSettingsView()
                    .tabItem {
                            Label("Notion Linking", systemImage: "folder.badge.plus")
                    }
            }
            .shadow(radius: 30)
            .padding(10)

            Button {
                state.showSettingsPanel = false
            } label: {
                Label("Close Settings", systemImage: "xmark.circle")
            }
            .buttonStyle(.plain)
        }
    }
}

struct SettingsPanelView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPanelView()
    }
}

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
                FolderSetupView().tabItem {
                    Label("Folder Setup", systemImage: "folder.badge.plus")
                }
                
                TutorialView().tabItem {
                    Label("Tutorial", systemImage: "book")
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

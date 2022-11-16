//
//  FolderSetupView.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 29.10.22.
//

import SwiftUI

struct ObsidianVaultSettings: View {
    @EnvironmentObject var state: AppState
    @State var showFileChooser = false
    @AppStorage("folderBookmarkData") private var folderBookmarkData: Data = Data()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(Color("ObsidianPurpleDark"))
                .frame(width: 500, height: 500)
                .shadow(radius: 20)
            
            VStack {
                Image("ObsidianLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                
                Text("Select Your Obsidian Vault")
                    .font(.title)
                    .padding(5)

                Text("Quickly insert links to your existing Obsidian markdown notes from this folder using the '[[' shortcut.")
                    .multilineTextAlignment(.center)
                    .padding(5)

                Button {
                    setupFolder()
                } label: {
                    Text("Select Vault")
                }
                .buttonStyle(.borderedProminent)
                .padding(5)
                
                Text("Currently " + String(state.markdownFileNames.count) + " Markdown File-Names Cached")
                    .font(.footnote)
                    .padding(5)
                
                Text(" ")
                Text("PS: If you would like to test out **Notion** integration, [please contact me](mailto:alexis.rondeau@gmail.com)")
            }
            .frame(width: 450, height: 450)
            
            Button {
                state.showSettingsPanel.toggle()
            } label: {
                Label("", systemImage: "xmark.circle.fill")
            }
            .buttonStyle(.plain)
            .offset(x: 250, y: -250)

        }
    }
    
    func setupFolder() {
        let panel = NSOpenPanel()

        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false

        if panel.runModal() == .OK {
            let url = panel.url
            do {
                let bookmarkData = try url?.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                self.folderBookmarkData = bookmarkData!
                state.cacheMarkdownFilenames(url: url!)
            } catch {
                print("Error while accessing folder!")
            }
        }
    }
}

struct FolderSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ObsidianVaultSettings()
    }
}

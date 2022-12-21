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
    @AppStorage("vaultUrl") private var vaultURL: URL = URL(fileURLWithPath: "~")

    var body: some View {
            VStack {
                Image("ObsidianLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                
                Text("Select Your Obsidian Vault Folder for Auto-Completion")
                    .padding(5)

                Button {
                    setupFolder()
                } label: {
                    Text("Select Vault Folder")
                }
                .buttonStyle(.borderedProminent)
                .padding(5)

                Text(String(state.markdownFileNames.count) + " markdown file-names from your vault are cached in-memory")
                    .font(.body)
                    .padding(5)
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
                self.vaultURL = url!

                state.cacheMarkdownFilenames(url: url!)
            } catch {
                print("Error while accessing folder!")
            }
        }
    }
    
    func resetVault() {
        state.resetEverything()
    }
}

struct FolderSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ObsidianVaultSettings()
    }
}

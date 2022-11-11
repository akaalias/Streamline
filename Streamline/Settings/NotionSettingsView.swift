//
//  NotionSettingsView.swift
//  Streamline
//
//  Created by Alexis Rondeau on 10.11.22.
//

import SwiftUI

struct NotionSettingsView: View {
    @EnvironmentObject var state: AppState
    @State var showFileChooser = false
    @AppStorage("folderBookmarkData") private var folderBookmarkData: Data = Data()

    var body: some View {
        VStack {
            Image("NotionLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            
            Text("Configure Your Notion Pages")
                .font(.title)
                .padding(5)
            
            Text("To get a feeling for **easily linking to your Notion pages** with Streamline's `[[` hotkey, please use this hack:\n\n 1. Export your Notion database of choice to Markdown (include sub-pages, exclude attachments)\n 2. Unzip the folder\n3. Click below to set it as the source for auto-completions:")
                .multilineTextAlignment(.center)
                .padding(5)
            
            Button {
                setupFolder()
            } label: {
                Text("Select Exported Notion Folder")
            }
            .buttonStyle(.borderedProminent)
            .padding(5)
            
            Text("Currently " + String(state.markdownFileNames.count) + " Markdown Notes Cached")
                .font(.footnote)
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
                state.cacheMarkdownFilenames(url: url!)
            } catch {
                print("Error while accessing folder!")
            }
        }
    }
}

struct NotionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotionSettingsView()
    }
}

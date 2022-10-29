//
//  FolderSetupView.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 29.10.22.
//

import SwiftUI

struct FolderSetupView: View {
    @EnvironmentObject var state: AppState
    @State var showFileChooser = false
    @AppStorage("folderBookmarkData") private var folderBookmarkData: Data = Data()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10.0, height: 10.0))
                .foregroundColor(.black.opacity(0.2))
                .frame(width: 400, height: 400)

            VStack {
                Text("Please Configure Your Folder")
                    .font(.largeTitle)
                Button {
                    setupFolder()
                } label: {
                    Text("Select Folder")
                }
                .buttonStyle(.bordered)
            }

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
        FolderSetupView()
    }
}

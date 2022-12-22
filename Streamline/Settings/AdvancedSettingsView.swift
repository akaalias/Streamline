//
//  AdvancedSettingsView.swift
//  Streamline
//
//  Created by Alexis Rondeau on 21.12.22.
//

import SwiftUI

struct AdvancedSettingsView: View {
    @EnvironmentObject var state: AppState
    @AppStorage("logStorage") private var logStorage: String = ""
    @State var result: String = ""
    @State private var selection: String?

    var body: some View {
        VStack {
            Text("Application Logs")
                .font(.title2)

            List(selection: $selection) {
                ForEach(splitLogs(), id: \.self) { item in
                    Text(item)
                }
            }
            .padding()
            .frame(height: 150)
            .listStyle(.automatic)
            
            Button("Reset All Settings, Logs and Caches") {
                state.resetEverything()
                result = "All settings, logs and caches were reset."
            }
            .padding()
            
            Text(result)
                .padding()

        }
    }
    
    private func splitLogs() -> [String] {
        return logStorage.components(separatedBy: " | ")
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView()
    }
}

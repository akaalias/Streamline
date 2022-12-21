//
//  AdvancedSettingsView.swift
//  Streamline
//
//  Created by Alexis Rondeau on 21.12.22.
//

import SwiftUI

struct AdvancedSettingsView: View {
    @EnvironmentObject var state: AppState
    @State var result: String = ""
    var body: some View {
        VStack {
            Button("Reset All Settings and Caches") {
                state.resetEverything()
                result = "All settings and caches were reset."
            }
            
            Text(result)
        }
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView()
    }
}

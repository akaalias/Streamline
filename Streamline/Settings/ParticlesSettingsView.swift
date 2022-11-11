//
//  ParticlesSettingsView.swift
//  Streamline
//
//  Created by Alexis Rondeau on 11.11.22.
//

import SwiftUI

struct ParticlesSettingsView: View {
    @AppStorage("showParticles") private var showParticles: Bool = false

    var body: some View {
        Button {
            showParticles.toggle()
        } label: {
            Text("Turn Particles " + (showParticles ? "Off" : "On"))
        }
        .buttonStyle(.borderedProminent)

    }
}

struct ParticlesSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ParticlesSettingsView()
    }
}

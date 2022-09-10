//
//  ContentView.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 24.08.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            GeometryReader{ geometry in
                HStack {
                    RageTextInput(displayMode: "Word")
                    Spacer(minLength: geometry.size.width / 2)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .padding()
        .frame(minWidth: 700, idealWidth: 900, maxWidth: .infinity, minHeight: 500, idealHeight: 700, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

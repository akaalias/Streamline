//
//  AppState.swift
//  RageEditor
//
//  Created by Alexis Rondeau on 11.09.22.
//

import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var allCharacters: [String] = []
}

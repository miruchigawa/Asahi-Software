//
//  AsahiApp.swift
//  Asahi
//
//  Created by kyon on 09/02/2025.
//

import SwiftUI

@main
struct AsahiApp: App {
    init() {
        // Initialize global number formatter
        _ = NumberFormatter.defaultFormatter
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}



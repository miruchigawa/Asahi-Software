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
        // Configure global number formatting
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        formatter.numberStyle = .decimal
        NumberFormatter.defaultFormatter = formatter
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

// Extension to provide global number formatter
extension NumberFormatter {
    static var defaultFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        formatter.numberStyle = .decimal
        return formatter
    }()
}

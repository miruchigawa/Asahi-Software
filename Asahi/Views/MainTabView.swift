import SwiftUI

struct MainTabView: View {
    @StateObject private var generationHistory = GenerationHistory()
    
    var body: some View {
        TabView {
            GenerateView()
                .environmentObject(generationHistory)
                .tabItem {
                    Label("Generate", systemImage: "wand.and.stars")
                }
            
            HistoryView()
                .environmentObject(generationHistory)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
} 
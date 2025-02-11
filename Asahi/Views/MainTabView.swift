import SwiftUI

struct MainTabView: View {
    @StateObject private var generationHistory = GenerationHistory()
    
    var body: some View {
        TabView(selection: $generationHistory.selectedTab) {
            GenerateView()
                .environmentObject(generationHistory)
                .tabItem {
                    Label("Generate", systemImage: "wand.and.stars")
                }
                .tag(0)
            
            HistoryView()
                .environmentObject(generationHistory)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
    }
} 
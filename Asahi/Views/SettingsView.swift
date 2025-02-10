import SwiftUI

struct SettingsView: View {
    @AppStorage("serverURL") private var serverURL = "http://127.0.0.1:7860"
    @StateObject private var healthCheck = HealthCheckViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Server Settings") {
                    TextField("Server URL", text: $serverURL)
                        .onChange(of: serverURL) { oldValue, newValue in
                            Task {
                                await healthCheck.checkServerHealth(url: serverURL)
                            }
                        }
                    
                    Button(action: {
                        Task {
                            await healthCheck.checkServerHealth(url: serverURL)
                        }
                    }) {
                        HStack {
                            Text("Check Server")
                            Spacer()
                            if healthCheck.isChecking {
                                ProgressView()
                            } else {
                                Image(systemName: healthCheck.isHealthy ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(healthCheck.isHealthy ? .green : .red)
                            }
                        }
                    }
                    .disabled(healthCheck.isChecking)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    }
                }
            }
            .navigationTitle("Settings")
            .task {
                await healthCheck.checkServerHealth(url: serverURL)
            }
        }
    }
}

@MainActor
class HealthCheckViewModel: ObservableObject {
    @Published var isHealthy = false
    @Published var isChecking = false
    
    func checkServerHealth(url: String) async {
        isChecking = true
        defer { isChecking = false }
        
        let service = SDWebUIService(baseURL: url)
        do {
            isHealthy = try await service.checkHealth()
        } catch {
            isHealthy = false
        }
    }
} 
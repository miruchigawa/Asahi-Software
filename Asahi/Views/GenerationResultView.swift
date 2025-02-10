import SwiftUI

struct GenerationResultView: View {
    let image: UIImage
    let results: GeneratedImage
    @Environment(\.dismiss) private var dismiss
    @State private var showingDebugInfo = false
    @State private var showSaveSuccess = false
    @State private var showCopySuccess = false
    
    var debugInfo: String {
        """
        Prompt: \(results.parameters.prompt)
        Negative Prompt: \(results.parameters.negativePrompt)
        Steps: \(results.parameters.steps)
        CFG Scale: \(results.parameters.cfgScale)
        Size: \(results.parameters.width)×\(results.parameters.height)
        Sampler: \(results.parameters.samplerName)
        Seed: \(results.info.seed)
        Model: \(results.info.modelName) (\(results.info.modelHash))
        """
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Generation Info")
                            .font(.headline)
                        
                        Group {
                            InfoRow(label: "Steps", value: "\(results.parameters.steps)")
                            InfoRow(label: "CFG Scale", value: "\(results.parameters.cfgScale)")
                            InfoRow(label: "Size", value: "\(results.parameters.width)×\(results.parameters.height)")
                            InfoRow(label: "Sampler", value: results.parameters.samplerName)
                            InfoRow(label: "Seed", value: "\(results.info.seed)")
                            InfoRow(label: "Model", value: "\(results.info.modelName) (\(results.info.modelHash))")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    HStack {
                        Button(action: {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            showSaveSuccess = true
                            
                            // Hide success message after delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSaveSuccess = false
                            }
                        }) {
                            Label("Save", systemImage: "square.and.arrow.down")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .overlay {
                            if showSaveSuccess {
                                SaveSuccessView(message: "Saved to Photos")
                            }
                        }
                        
                        Button(action: {
                            UIPasteboard.general.string = debugInfo
                            showCopySuccess = true
                            
                            // Hide success message after delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showCopySuccess = false
                            }
                        }) {
                            Label("Copy Info", systemImage: "doc.on.doc")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .overlay {
                            if showCopySuccess {
                                SaveSuccessView(message: "Copied to Clipboard")
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SaveSuccessView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.75))
            .cornerRadius(8)
            .transition(.opacity)
            .animation(.easeInOut, value: true)
            .offset(y: 30)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
    }
} 

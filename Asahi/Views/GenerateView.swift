import SwiftUI

struct GenerateView: View {
    @StateObject private var viewModel = GenerateViewModel()
    @EnvironmentObject var history: GenerationHistory
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    PromptInputView(prompt: $viewModel.settings.prompt,
                                  negativePrompt: $viewModel.settings.negativePrompt)
                    
                    GenerationSettingsView(settings: $viewModel.settings)
                    
                    if let image = viewModel.generatedImage {
                        GeneratedImageView(image: image)
                    }
                    
                    GenerateButton(isGenerating: viewModel.isGenerating) {
                        Task {
                            await viewModel.generateImage()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Generate")
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .sheet(isPresented: $viewModel.showResult) {
                if let image = viewModel.generatedImage,
                   let result = viewModel.generationResult {
                    GenerationResultView(image: image, results: result)
                }
            }
        }
    }
}

struct PromptInputView: View {
    @Binding var prompt: String
    @Binding var negativePrompt: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Prompt")
                .font(.headline)
            TextEditor(text: $prompt)
                .frame(height: 100)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Text("Negative Prompt")
                .font(.headline)
            TextEditor(text: $negativePrompt)
                .frame(height: 100)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
} 
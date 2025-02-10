import Foundation
import SwiftUI

@MainActor
class GenerateViewModel: ObservableObject {
    @AppStorage("serverURL") private var serverURL = "http://127.0.0.1:7860"
    @Published var settings = GenerationSettings()
    @Published var generatedImage: UIImage?
    @Published var generationResult: GeneratedImage?
    @Published var isGenerating = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showResult = false
    
    private var service: SDWebUIService {
        SDWebUIService(baseURL: serverURL)
    }
    
    func generateImage() async {
        guard !settings.prompt.isEmpty else {
            showError(message: "Please enter a prompt")
            return
        }
        
        isGenerating = true
        
        do {
            let result = try await service.generateImage(settings: settings)
            
            if let base64String = result.images.first,
               let imageData = Data(base64Encoded: base64String),
               let image = UIImage(data: imageData) {
                generatedImage = image
                generationResult = result
                showResult = true
            }
        } catch {
            showError(message: error.localizedDescription)
        }
        
        isGenerating = false
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
} 
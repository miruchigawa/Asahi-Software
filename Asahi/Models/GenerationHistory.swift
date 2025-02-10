import Foundation

class GenerationHistory: ObservableObject {
    @Published var items: [GeneratedImage] = []
    
    func addGeneration(_ generation: GeneratedImage) {
        items.insert(generation, at: 0)
    }
    
    func clearHistory() {
        items.removeAll()
    }
} 
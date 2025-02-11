import Foundation

class GenerationHistory: ObservableObject {
    @Published var items: [GeneratedImage] = [] {
        didSet {
            saveToStorage()
        }
    }
    @Published var currentSettings: GenerationSettings = GenerationSettings()
    @Published var selectedTab: Int = 0
    
    private let storageKey = "generationHistory"
    
    init() {
        loadFromStorage()
    }
    
    func addGeneration(_ generation: GeneratedImage) {
        items.insert(generation, at: 0)
    }
    
    func clearHistory() {
        items.removeAll()
    }
    
    func reuseSettings(_ item: GeneratedImage) {
        currentSettings = GenerationSettings(
            prompt: item.parameters.prompt,
            negativePrompt: item.parameters.negativePrompt,
            steps: item.parameters.steps,
            cfgScale: Double(item.parameters.cfgScale),
            width: item.parameters.width,
            height: item.parameters.height,
            samplerName: item.parameters.samplerName,
            seed: item.info.seed,
            batchSize: 1,
            modelName: item.info.modelName
        )
        selectedTab = 0
        
        objectWillChange.send()
    }
    
    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadFromStorage() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([GeneratedImage].self, from: data) {
            items = decoded
        }
    }
} 
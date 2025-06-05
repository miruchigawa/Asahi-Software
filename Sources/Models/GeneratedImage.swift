import Foundation

struct GeneratedImage: Codable, Identifiable {
    var id: UUID
    let images: [String]
    let info: GenerateImageInfo
    let parameters: GenerateImageParameters
    
    private enum CodingKeys: String, CodingKey {
        case id, images, info, parameters
    }
    
    init() {
        self.id = UUID()
        self.images = []
        self.info = GenerateImageInfo(seed: -1, modelName: "None", modelHash: "None")
        self.parameters = GenerateImageParameters(prompt: "", negativePrompt: "", seed: -1, steps: 20, cfgScale: 7, width: 512, height: 512, samplerName: "Euler a")
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode id if present, otherwise create new UUID
        if let decodedId = try? container.decode(UUID.self, forKey: .id) {
            self.id = decodedId
        } else {
            self.id = UUID()
        }
        
        do {
            self.images = try container.decode([String].self, forKey: .images)
        } catch {
            print("Error decoding images: \(error)")
            throw error
        }
        
        do {
            self.parameters = try container.decode(GenerateImageParameters.self, forKey: .parameters)
        } catch {
            print("Error decoding parameters: \(error)")
            throw error
        }
        
        do {
            if let infoString = try? container.decode(String.self, forKey: .info),
               let infoData = infoString.data(using: .utf8) {
                do {
                    self.info = try JSONDecoder().decode(GenerateImageInfo.self, from: infoData)
                } catch {
                    print("Error decoding info JSON: \(error)")
                    self.info = GenerateImageInfo(seed: parameters.seed, modelName: "None", modelHash: "None")
                }
            } else {
                // Try decoding info directly as an object
                self.info = try container.decode(GenerateImageInfo.self, forKey: .info)
            }
        } catch {
            print("Error decoding info: \(error)")
            self.info = GenerateImageInfo(seed: parameters.seed, modelName: "None", modelHash: "None")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(images, forKey: .images)
        try container.encode(parameters, forKey: .parameters)
        try container.encode(info, forKey: .info)
    }
}

struct GenerateImageInfo: Codable {
    let seed: Int
    let modelName: String
    let modelHash: String
    
    private enum CodingKeys: String, CodingKey {
        case seed
        case modelName = "sd_model_name"
        case modelHash = "sd_model_hash"
    }
}

struct GenerateImageParameters: Codable {
    let prompt: String
    let negativePrompt: String
    let seed: Int
    let steps: Int
    let cfgScale: Int
    let width: Int
    let height: Int
    let samplerName: String
    
    private enum CodingKeys: String, CodingKey {
        case prompt
        case negativePrompt = "negative_prompt"
        case seed
        case steps
        case cfgScale = "cfg_scale"
        case width
        case samplerName = "sampler_name"
        case height
    }
}

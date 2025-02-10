import Foundation

struct GeneratedImage: Codable, Identifiable {
    let id: UUID = UUID()
    let images: [String]
    let info: GenerateImageInfo
    let parameters: GenerateImageParameters
    
    private enum CodingKeys: String, CodingKey {
        case images, info, parameters
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
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
            let infoString = try container.decode(String.self, forKey: .info)
            if let infoData = infoString.data(using: .utf8) {
                do {
                    let decodedInfo = try JSONDecoder().decode(GenerateImageInfo.self, from: infoData)
                    self.info = decodedInfo
                } catch {
                    print("Error decoding info JSON: \(error)")
                    print("Info string content: \(infoString)")
                    self.info = GenerateImageInfo(seed: parameters.seed, modelName: "None", modelHash: "None")
                }
            } else {
                print("Failed to convert info string to data")
                self.info = GenerateImageInfo(seed: parameters.seed, modelName: "None", modelHash: "None")
            }
        } catch {
            print("Error decoding info string: \(error)")
            throw error
        }
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

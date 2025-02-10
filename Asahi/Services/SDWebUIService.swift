import Foundation

enum SDWebUIError: Error {
    case serverNotReachable
    case invalidResponse
    case invalidURL
    case unknown(String)
}

class SDWebUIService {
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func checkHealth() async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/internal/ping") else {
            throw SDWebUIError.invalidURL
        }
        
        do {
            let (_, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw SDWebUIError.invalidResponse
            }
            return httpResponse.statusCode == 200
        } catch {
            throw SDWebUIError.serverNotReachable
        }
    }
    
    func generateImage(settings: GenerationSettings) async throws -> GeneratedImage {
        guard let url = URL(string: "\(baseURL)/sdapi/v1/txt2img") else {
            throw SDWebUIError.invalidURL
        }
        
        let parameters: [String: Any] = [
            "prompt": settings.prompt,
            "negative_prompt": settings.negativePrompt,
            "steps": settings.steps,
            "cfg_scale": settings.cfgScale,
            "width": settings.width,
            "height": settings.height,
            "sampler_name": settings.samplerName,
            "seed": settings.seed,
            "batch_size": settings.batchSize,
            "override_settings": [
                "sd_model_checkpoint": settings.modelName
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(GeneratedImage.self, from: data)
        return result
    }
} 

struct GenerationSettings: Codable {
    var prompt: String = ""
    var negativePrompt: String = ""
    var steps: Int = 20
    var cfgScale: Double = 7.0
    var width: Int = 512
    var height: Int = 512
    var samplerName: String = "Euler a"
    var seed: Int = -1
    var batchSize: Int = 1
    var modelName: String = "v1-5-pruned-emaonly"
    
    static let samplers = [
        "Euler a", "Euler", "LMS", "Heun", "DPM2", 
        "DPM2 a", "DPM++ 2S a", "DPM++ 2M", "DPM++ SDE"
    ]
} 
import SwiftUI

/*
 Global Style Guide:
 - No number grouping (e.g., use 1024 instead of 1,024)
 - All numeric inputs should support both slider and keyboard input
 - Width and height inputs should allow custom values
 */

struct GenerationSettingsView: View {
    @Binding var settings: GenerationSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Generation Settings")
                .font(.headline)
            
            Group {
                VStack(alignment: .leading) {
                    Text("Steps: \(settings.steps)")
                    HStack {
                        Slider(value: .init(
                            get: { Double(settings.steps) },
                            set: { settings.steps = Int($0) }
                        ), in: 1...150, step: 1)
                        
                        TextField("", value: $settings.steps, formatter: NumberFormatter.defaultFormatter)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("CFG Scale: \(String(format: "%.1f", settings.cfgScale))")
                    HStack {
                        Slider(value: $settings.cfgScale, in: 1...30)
                        TextField("", value: $settings.cfgScale, formatter: NumberFormatter.defaultFormatter)
                            .keyboardType(.decimalPad)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                HStack {
                    Text("Size:")
                    TextField("Width", value: $settings.width, formatter: NumberFormatter.defaultFormatter)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("×")
                    TextField("Height", value: $settings.height, formatter: NumberFormatter.defaultFormatter)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Sampler:")
                    Picker("Sampler", selection: $settings.samplerName) {
                        ForEach(GenerationSettings.samplers, id: \.self) { sampler in
                            Text(sampler).tag(sampler)
                        }
                    }
                }
                
                HStack {
                    Text("Seed:")
                    TextField("Random", value: $settings.seed, formatter: NumberFormatter.defaultFormatter)
                        .keyboardType(.numberPad)
                    Button("🎲") {
                        settings.seed = Int.random(in: 0...9999999999)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
} 
import SwiftUI

struct GenerateButton: View {
    let isGenerating: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isGenerating {
                    ProgressView()
                        .tint(.white)
                }
                Text(isGenerating ? "Generating..." : "Generate")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isGenerating ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isGenerating)
    }
} 

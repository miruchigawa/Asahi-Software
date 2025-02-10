import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var history: GenerationHistory
    
    var body: some View {
        NavigationView {
            List {
                ForEach(history.items) { item in
                    HistoryItemView(item: item)
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        history.clearHistory()
                    }) {
                        Text("Clear")
                    }
                }
            }
        }
    }
}

struct HistoryItemView: View {
    let item: GeneratedImage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let base64String = item.images.first,
               let imageData = Data(base64Encoded: base64String),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(8)
            }
            
            Text(item.parameters.prompt)
                .font(.headline)
                .lineLimit(2)
            
            if !item.parameters.negativePrompt.isEmpty {
                Text("Negative: \(item.parameters.negativePrompt)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Text("Steps: \(item.parameters.steps) | Seed: \(item.info.seed)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
} 

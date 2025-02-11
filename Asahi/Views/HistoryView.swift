import SwiftUI

extension View {
    func margin(_ edges: EdgeInsets) -> some View {
        self
            .padding(edges)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
    }
}

struct HistoryView: View {
    @EnvironmentObject var history: GenerationHistory
    
    var body: some View {
        NavigationView {
            List {
                ForEach(history.items) { item in
                    HistoryItemView(item: item)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
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
    @EnvironmentObject var history: GenerationHistory
    @Environment(\.dismiss) private var dismiss
    @State private var showSaveSuccess = false
    @State private var showReuseSuccess = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let base64String = item.images.first,
               let imageData = Data(base64Encoded: base64String),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 48, height: UIScreen.main.bounds.width - 48)
                    .clipped()
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.parameters.prompt)
                    .font(.headline)
                    .lineLimit(2)
                
                if !item.parameters.negativePrompt.isEmpty {
                    Text("Negative: \(item.parameters.negativePrompt)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Text("Steps: \(NumberFormatter.defaultFormatter.string(from: NSNumber(value: item.parameters.steps)) ?? "0") | CFG: \(NumberFormatter.defaultFormatter.string(from: NSNumber(value: item.parameters.cfgScale)) ?? "0") | Seed: \(NumberFormatter.defaultFormatter.string(from: NSNumber(value: item.info.seed)) ?? "0")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2, y: 1)
        .margin(.init(top: 8, leading: 20, bottom: 8, trailing: 20))
        .contextMenu {
            if let base64String = item.images.first,
               let imageData = Data(base64Encoded: base64String),
               let uiImage = UIImage(data: imageData) {
                Button(action: {
                    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                    showSaveSuccess = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSaveSuccess = false
                    }
                }) {
                    Label("Save to Photos", systemImage: "square.and.arrow.down")
                }
            }
            
            Button(action: {
                history.reuseSettings(item)
                showReuseSuccess = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showReuseSuccess = false
                }
            }) {
                Label("Reuse Settings", systemImage: "arrow.triangle.2.circlepath")
            }
        }
        .overlay {
            if showSaveSuccess {
                SaveSuccessView(message: "Saved to Photos")
            }
            if showReuseSuccess {
                SaveSuccessView(message: "Settings Applied")
            }
        }
    }
} 

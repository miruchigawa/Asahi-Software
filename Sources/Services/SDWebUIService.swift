import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum SDWebUIError: Error {
    case serverNotReachable
    case invalidResponse
    case invalidURL
    case decodingFailure
}

final class SDWebUIService {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: String, session: URLSession = .shared) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid baseURL")
        }
        self.baseURL = url
        self.session = session
    }

    func checkHealth() async throws -> Bool {
        let url = baseURL.appendingPathComponent("/internal/ping")
        do {
            let (_, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw SDWebUIError.invalidResponse
            }
            return httpResponse.statusCode == 200
        } catch {
            throw SDWebUIError.serverNotReachable
        }
    }

    func generateImage(settings: GenerationSettings) async throws -> GeneratedImage {
        let url = baseURL.appendingPathComponent("/sdapi/v1/txt2img")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: settings.requestParameters)

        let (data, _) = try await session.data(for: request)
        do {
            return try JSONDecoder().decode(GeneratedImage.self, from: data)
        } catch {
            throw SDWebUIError.decodingFailure
        }
    }
}

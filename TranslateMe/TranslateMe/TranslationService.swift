import Foundation

enum TranslationServiceError: LocalizedError {
    case invalidURL
    case emptyResponse
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The translation URL could not be built."
        case .emptyResponse: return "The translation service returned no data."
        case .decodingFailed: return "The translation response could not be decoded."
        }
    }
}

enum TranslationService {
    static func translate(text: String,
                          from source: String,
                          to target: String,
                          completion: @escaping (Result<String, Error>) -> Void) {
        var components = URLComponents(string: "https://api.mymemory.translated.net/get")
        components?.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "langpair", value: "\(source)|\(target)")
        ]

        guard let url = components?.url else {
            completion(.failure(TranslationServiceError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(TranslationServiceError.emptyResponse))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(TranslationResponse.self, from: data)
                completion(.success(decoded.responseData.translatedText))
            } catch {
                completion(.failure(TranslationServiceError.decodingFailed))
            }
        }.resume()
    }
}

private struct TranslationResponse: Decodable {
    let responseData: ResponseData

    struct ResponseData: Decodable {
        let translatedText: String
    }
}

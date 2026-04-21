import Foundation
import FirebaseFirestore

struct TranslationItem: Identifiable, Codable {
    @DocumentID var id: String?
    var sourceText: String
    var translatedText: String
    var sourceLanguage: String
    var targetLanguage: String
    var createdAt: Date
}

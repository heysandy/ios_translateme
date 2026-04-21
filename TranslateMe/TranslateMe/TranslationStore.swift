import Foundation
import FirebaseFirestore

@MainActor
final class TranslationStore: ObservableObject {
    @Published var items: [TranslationItem] = []

    private let collectionName = "translations"
    private var db: Firestore { Firestore.firestore() }
    private var listener: ListenerRegistration?

    init() {
        fetch()
    }

    deinit {
        listener?.remove()
    }

    func fetch() {
        listener?.remove()
        listener = db.collection(collectionName)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }
                if let error {
                    print("Fetch error: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                self.items = documents.compactMap { try? $0.data(as: TranslationItem.self) }
            }
    }

    func save(sourceText: String,
              translatedText: String,
              sourceLanguage: String,
              targetLanguage: String) {
        let item = TranslationItem(
            sourceText: sourceText,
            translatedText: translatedText,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            createdAt: Date()
        )

        do {
            _ = try db.collection(collectionName).addDocument(from: item)
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }

    func clear() {
        db.collection(collectionName).getDocuments { [weak self] snapshot, error in
            guard let self else { return }
            if let error {
                print("Clear fetch error: \(error.localizedDescription)")
                return
            }
            let batch = self.db.batch()
            snapshot?.documents.forEach { batch.deleteDocument($0.reference) }
            batch.commit { error in
                if let error {
                    print("Clear commit error: \(error.localizedDescription)")
                }
            }
        }
    }
}

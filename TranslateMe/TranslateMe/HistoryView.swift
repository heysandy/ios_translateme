import SwiftUI

struct HistoryView: View {
    @ObservedObject var store: TranslationStore

    var body: some View {
        VStack {
            if store.items.isEmpty {
                Spacer()
                Text("No saved translations yet.")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(store.items) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.sourceText)
                                .font(.body)
                                .fontWeight(.semibold)
                            Text(item.translatedText)
                                .font(.body)
                                .foregroundColor(.blue)
                            Text("\(item.sourceLanguage.uppercased()) → \(item.targetLanguage.uppercased())")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Saved Translations")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    store.clear()
                } label: {
                    Text("Clear")
                }
                .disabled(store.items.isEmpty)
            }
        }
        .onAppear {
            store.fetch()
        }
    }
}

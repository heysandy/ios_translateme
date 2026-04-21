import SwiftUI

struct ContentView: View {
    @StateObject private var store = TranslationStore()
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var isTranslating: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Translate Me")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 8)

                Spacer().frame(height: 80)

                TextField("Enter text", text: $inputText)
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )

                Button(action: translate) {
                    HStack {
                        Spacer()
                        if isTranslating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Translate Me")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isTranslating)

                VStack(alignment: .leading) {
                    Text(translatedText)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
                }
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue.opacity(0.6), lineWidth: 1)
                )

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                NavigationLink(destination: HistoryView(store: store)) {
                    Text("View Saved Translations")
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }

    private func translate() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        isTranslating = true
        errorMessage = nil

        TranslationService.translate(text: trimmed, from: "en", to: "es") { result in
            DispatchQueue.main.async {
                isTranslating = false
                switch result {
                case .success(let translation):
                    translatedText = translation
                    store.save(sourceText: trimmed,
                               translatedText: translation,
                               sourceLanguage: "en",
                               targetLanguage: "es")
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

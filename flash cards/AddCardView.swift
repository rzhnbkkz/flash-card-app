import SwiftUI
import SwiftData

struct AddCardView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    let deck: Deck
    
    @State private var front = ""
    @State private var back = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Front") {
                    TextField("Question", text: $front)
                }
                Section("Back") {
                    TextField("Answer", text: $back)
                }
            }
            .navigationTitle("New Card")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !front.isEmpty && !back.isEmpty else { return }
                        let card = Card(front: front, back: back)
                        card.deck = deck
                        deck.cards.append(card)
                        context.insert(card)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

import SwiftUI
import SwiftData

struct DeckView: View {
    @Environment(\.modelContext) private var context
    let deck: Deck
    
    @State private var showingAddCard = false
    @State private var newFront = ""
    @State private var newBack = ""
    
    var body: some View {
        var canReview: Bool {
            !deck.cards.isEmpty
        }
        var deckRating: Double {
            guard !deck.cards.isEmpty else { return 0 }
            return deck.cards.map { $0.rating }.reduce(0, +) / Double(deck.cards.count)
        }
        Section {
            HStack {
                Label("\(deck.cards.count) cards", systemImage: "rectangle.stack")
                Spacer()
                Label("\(Int(deckRating * 100))% mastery", systemImage: "chart.bar.fill")
            }
            .foregroundStyle(.secondary)
            .padding()
        }
        List {
            ForEach(deck.cards) { card in
                VStack(alignment: .leading) {
                    Text(card.front)
                        .font(.headline)
                    Text(card.back)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { context.delete(deck.cards[$0]) }
            }
        }
        .navigationTitle(deck.name)
        .sheet(isPresented: $showingAddCard) {
            AddCardView(deck: deck)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Card", systemImage: "plus") {
                    showingAddCard = true
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: ReviewView(deck: deck)) {
                    Label("Review", systemImage: "play.fill")
                }
                .disabled(!canReview)
            }
        }
    }
}

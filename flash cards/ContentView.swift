import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var decks: [Deck]

    var sortedDecks: [Deck] {
        sortByRating
            ? decks.sorted { $0.deckRating < $1.deckRating }
            : decks.sorted { $0.name < $1.name }
    }
    
    @State private var showingAddDeck = false
    @State private var newDeckName = ""
    @State private var sortByRating = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedDecks) { deck in
                    NavigationLink(deck.name, destination: DeckView(deck: deck))
                }
                .onDelete { indexSet in
                    indexSet.forEach { context.delete(decks[$0]) }
                }
            }
            .navigationTitle("Decks")
            .toolbar {
                Button("Add Deck", systemImage: "plus") {
                    showingAddDeck = true
                }
                Button(sortByRating ? "Sort: Rating" : "Sort: Name", systemImage: "arrow.up.arrow.down") {
                    sortByRating.toggle()
                }
            }
            .alert("New Deck", isPresented: $showingAddDeck) {
                TextField("Deck name", text: $newDeckName)
                Button("Create") {
                    guard !newDeckName.isEmpty else { return }
                    context.insert(Deck(name: newDeckName))
                    newDeckName = ""
                }
                Button("Cancel", role: .cancel) { newDeckName = "" }
            }
        }
    }
}

#Preview {
    ContentView()
}

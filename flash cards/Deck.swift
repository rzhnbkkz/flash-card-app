import SwiftData

@Model class Deck {
    var name : String
    @Relationship(deleteRule: .cascade) var cards : [Card] = []
    
    var deckRating: Double {
        guard !cards.isEmpty else { return 0 }
        return cards.map { $0.rating }.reduce(0, +) / Double(cards.count)
    }
    
    init(name : String) {
        self.name = name
    }
}

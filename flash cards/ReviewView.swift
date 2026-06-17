import SwiftUI

struct ReviewView: View {
    let deck: Deck
    
    @State private var currentCard: Card?
    @State private var isFlipped = false
    
    var body: some View {
        VStack(spacing: 24) {
            if let card = currentCard {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                    
                    Text(isFlipped ? card.back : card.front)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                }
                .frame(maxWidth: .infinity, minHeight: 200)
                .padding()
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .onTapGesture {
                    withAnimation(.spring(duration: 0.5)) {
                        isFlipped.toggle()
                    }
                }
                
                if isFlipped {
                    HStack(spacing: 16) {
                        Button("Incorrect") {
                            record(correct: false)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        
                        Button("Correct") {
                            record(correct: true)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                } else {
                    Text("Tap to flip")
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text("Rating: \(String(format: "%.0f%%", (currentCard?.rating ?? 0) * 100))")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                
            } else {
                Text("No cards in this deck.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Review")
        .onAppear { currentCard = pickCard() }
    }
    
    func record(correct: Bool) {
        guard let card = currentCard else { return }
        if correct { card.correct += 1 }
        card.total += 1
        isFlipped = false
        currentCard = pickCard()
    }
    
    func pickCard() -> Card? {
        let cards = deck.cards
        guard !cards.isEmpty else { return nil }
        let weights = cards.map { 1.0 - $0.rating + 0.1 }
        let total = weights.reduce(0, +)
        var random = Double.random(in: 0..<total)
        for (card, weight) in zip(cards, weights) {
            random -= weight
            if random <= 0 { return card }
        }
        return cards.last
    }
}

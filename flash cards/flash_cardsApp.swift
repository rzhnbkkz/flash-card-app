import SwiftUI
import SwiftData

@main
struct flash_cardsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Deck.self, Card.self])
    }
}

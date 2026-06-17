import SwiftData

@Model class Card {
    var front : String
    var back : String
    var correct : Int
    var total : Int
    var deck : Deck?
    var rating : Double {total == 0 ? 0.5 : Double(correct) / Double(total)}
    
    init(front : String, back : String) {
        self.front = front
        self.back = back
        correct = 0
        total = 0
    }
}


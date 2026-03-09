import Foundation

enum ComponentType: String, Codable {
    case title = "TITLE"
    case spacer = "SPACER"
    case button = "BUTTON"
    case card = "CARD"
}

enum ActionType: String, Codable {
    case navigate = "NAVIGATE"
}

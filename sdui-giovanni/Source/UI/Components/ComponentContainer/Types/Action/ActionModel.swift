import Foundation

protocol ActionModelProtocol: Codable {
    var actionType: ActionType { get }
}

struct PrintActionModel: ActionModelProtocol {
    var actionType: ActionType = .print
    let content: String
}

struct NavigateActionModel: ActionModelProtocol {
    var actionType: ActionType = .navigate
    let route: String?
}

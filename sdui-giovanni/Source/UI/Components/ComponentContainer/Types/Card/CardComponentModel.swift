import Foundation

struct CardComponentModel: ComponentModelProtocol {
    var componentType: ComponentType = .card
    
    let imageName: String
    let title: String
    let text: String
    let titleFontSize: Int?
    let textFontSize: Int?
    let titleColor: String?
    let textColor: String?
    
    let action: [String: AnyCodable]?
}

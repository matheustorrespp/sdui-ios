import Foundation

class ActionFactory {

    func makeAction(from dictionary: [String: AnyCodable]?) -> ActionModelProtocol? {
        guard let dictionary,
              let actionType = getActionType(dictionary) else {
            return nil
        }

        switch actionType {
        case .print:
            return decode(PrintActionModel.self, from: dictionary)
        case .navigate:
            return decode(NavigateActionModel.self, from: dictionary)
        }
    }

    // MARK: - PRIVATE METHODS

    private func getActionType(_ dictionary: [String: AnyCodable]) -> ActionType? {
        guard let type = dictionary["actionType"]?.value as? String else {
            return nil
        }
        return ActionType(rawValue: type)
    }

    private func decode<T: ActionModelProtocol>(_ type: T.Type, from dictionary: [String: AnyCodable]) -> T? {
        do {
            let data = try JSONEncoder().encode(dictionary)
            let jsonObject = try JSONSerialization.jsonObject(with: data)

            guard JSONSerialization.isValidJSONObject(jsonObject) else { return nil }

            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
            return try JSONDecoder().decode(T.self, from: jsonData)
        } catch {
            return nil
        }
    }
}

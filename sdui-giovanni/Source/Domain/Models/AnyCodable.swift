import Foundation

public struct AnyCodable {
    public let value: Any?

    public init(value: Any) {
        self.value = value
    }
}

extension AnyCodable: Decodable {
    struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            var result = [String: Any]()
            try container.allKeys.forEach { (key) throws in
                result[key.stringValue] = try container.decode(AnyCodable.self, forKey: key).value
            }
            value = result
            return
        }

        if var container = try? decoder.unkeyedContainer() {
            var result = [Any]()
            while !container.isAtEnd {
                guard let element = try container.decode(AnyCodable.self).value else {
                    continue
                }
                result.append(element)
            }
            value = result
            return
        }

        if let container = try? decoder.singleValueContainer() {
            if let intValue = try? container.decode(Int.self) {
                value = intValue
                return
            }

            if let doubleValue = try? container.decode(Double.self) {
                value = doubleValue
                return
            }

            if let decimalValue = try? container.decode(Decimal.self) {
                value = decimalValue
                return
            }

            if let boolValue = try? container.decode(Bool.self) {
                value = boolValue
                return
            }

            if let stringValue = try? container.decode(String.self) {
                value = stringValue
                return
            }

            value = nil
            return
        }

        value = nil
    }
}

extension AnyCodable: Encodable {
    public func encode(to encoder: Encoder) throws {
        if let array = value as? [Any] {
            var container = encoder.unkeyedContainer()
            for value in array {
                let decodable = AnyCodable(value: value)
                try container.encode(decodable)
            }
            return
        }

        if let dictionary = value as? [String: Any] {
            var container = encoder.container(keyedBy: CodingKeys.self)
            for (key, value) in dictionary {
                guard let codingKey = CodingKeys(stringValue: key) else {
                    continue
                }
                let decodable = AnyCodable(value: value)
                try container.encode(decodable, forKey: codingKey)
            }
            return
        }

        var container = encoder.singleValueContainer()

        if let intVal = value as? Int {
            try container.encode(intVal)
            return
        }

        if let doubleVal = value as? Double {
            try container.encode(doubleVal)
            return
        }

        if let decimalVal = value as? Decimal {
            try container.encode(decimalVal)
            return
        }

        if let boolVal = value as? Bool {
            try container.encode(boolVal)
            return
        }

        if let stringVal = value as? String {
            try container.encode(stringVal)
            return
        }
    }
}

extension AnyCodable: Equatable, Hashable {
    public func hash(into hasher: inout Hasher) {
        if let intVal = value as? Int {
            hasher.combine(intVal)
            return
        }

        if let doubleVal = value as? Double {
            hasher.combine(doubleVal)
            return
        }

        if let decimalVal = value as? Decimal {
            hasher.combine(decimalVal)
            return
        }

        if let boolVal = value as? Bool {
            hasher.combine(boolVal)
            return
        }

        if let stringVal = value as? String {
            hasher.combine(stringVal)
            return
        }
    }

    public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as Decimal, rhs as Decimal):
            return lhs == rhs
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as [String: AnyCodable], rhs as [String: AnyCodable]):
            return lhs == rhs
        case let (lhs as [AnyCodable], rhs as [AnyCodable]):
            return lhs == rhs
        case let (lhs as [Any], rhs as [Any]):
            return NSArray(array: lhs) == NSArray(array: rhs)
        case let (lhs as [String: Any], rhs as [String: Any]):
            return NSDictionary(dictionary: lhs) == NSDictionary(dictionary: rhs)
        case is (NSNull, NSNull):
            return true
        default:
            return false
        }
    }
}

// MARK: Append AnyCodable
extension Dictionary where Key == String, Value == AnyCodable {
    public mutating func append(dict: [String: AnyCodable]) {
        dict.forEach { (key, value) in
            updateValue(value, forKey: key)
        }
    }
}

// MARK: - Convert Dict to AnyCodable
extension Dictionary where Key == String {
    public var engineeringTrackerAttributes: [String: AnyCodable] {
        let dictWithoutNilValues = compactMapValues { isNil($0) ? nil : $0 }
        return dictWithoutNilValues.mapValues { AnyCodable(value: $0) }
    }
    
    private func isNil(_ value: Any?) -> Bool {
        return value as AnyObject is NSNull
    }
}

extension CellState: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0: self = .empty
        case 1: self = .born
        case 2: self = .alive
        case 3: self = .died
        default: throw CodingError.unknownValue
        }
    }

    enum Key: CodingKey {
        case rawValue
    }

    enum CodingError: Error {
        case unknownValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .empty: try container.encode(0, forKey: .rawValue)
        case .born: try container.encode(1, forKey: .rawValue)
        case .alive: try container.encode(2, forKey: .rawValue)
        case .died: try container.encode(3, forKey: .rawValue)
        }
    }
}

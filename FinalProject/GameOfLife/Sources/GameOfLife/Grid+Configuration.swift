//
//  Grid+Configuration.swift
//  SwiftUIGameOfLife
//
import Combine
import Foundation

public extension Grid {
    struct Configuration: Codable, Equatable, Identifiable {
        public private(set) var id: UUID
        
        public static func == (lhs: Array<Element>.Configuration, rhs: Array<Element>.Configuration) -> Bool {
            lhs.title == rhs.title && lhs.contents == rhs.contents
        }
        
        public let title : String
        public var shape: String {
            "Rows: \(minRow) - \(maxRow), Cols: \(minCol) - \(maxCol), Number Living: \(numLiving)"
        }
        private let _contents: [[Int]: Void]
        
        public enum Error: Swift.Error {
            case invalidCount
            case invalidValue
        }
        
        public init(title: String, contents: [[Int]]) throws {
            guard contents.allSatisfy({ $0.count == 2 }) else {
                throw Grid.Configuration.Error.invalidCount
            }
            guard contents.allSatisfy({ $0[0] >= 0 && $0[1] >= 0 }) else {
                throw Grid.Configuration.Error.invalidValue
            }
            
            self.id = UUID()
            self.title = title
            self._contents = Dictionary(uniqueKeysWithValues: contents.map { ($0, ()) })
        }
        
        // MARK: Configuration Sizes
        public var contents: [[Int]] { _contents.map    { $0.0 } }
        public var maxCoord: Int     { contents.flatMap { $0 }    .max() ?? 0 }
        public var maxRow: Int       { contents.map     { $0[0]  }.max() ?? 0 }
        public var maxCol: Int       { contents.map     { $0[1]  }.max() ?? 0 }
        public var minCoord: Int     { contents.flatMap { $0 }    .min() ?? 0 }
        public var minRow: Int       { contents.map     { $0[0]  }.min() ?? 0 }
        public var minCol: Int       { contents.map     { $0[1]  }.min() ?? 0 }
        public var numLiving: Int    { contents.count }
        
        // MARK: Configuration Resizing
        public var fitted: Grid.Configuration {
            let minR = minRow, minC = minCol
            return try! Grid.Configuration(
                title: title,
                contents: contents.map { [$0[0] - minR, $0[1] - minC] }
            )
        }
        public var centered: Grid.Configuration {
            let max = fitted.maxCoord, maxR = fitted.maxRow, maxC = fitted.maxCol
            return try! Grid.Configuration(
                title: title,
                contents: fitted.contents.map { [$0[0] + max - (maxR / 2), $0[1] + max - (maxC / 2)] }
            )
        }
        
        // MARK: Grid from Configuration
        public var smallGrid: Grid {
            let fMax = fitted.maxCoord * 2 + 1
            return grid(rows: fMax, cols: fMax)
        }
        
        public var defaultGrid: Grid {
            let max = maxCoord * 2
            return grid(rows: max, cols: max)
        }
        
        public func grid(rows: Int, cols: Int) -> Grid {
            Grid(rows, cols) {
                guard let _ = self._contents[[$0, $1]] else { return .empty }
                return .alive
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case title
            case contents
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let title = try values.decode(String.self, forKey: .title)
            let contents = try values.decode([[Int]].self, forKey: .contents)
            self = try Self(title: title, contents: contents)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
            try container.encode(contents, forKey: .contents)
        }
    }
}

// MARK: Configuration from Grid
public extension Grid {
    var allOffsets: [Grid.Offset] {
        [[Grid.Offset]](self.size.rows, self.size.cols, Grid.Offset.init)
            .flatMap(identity)
    }

    func living(_ offsets: [Offset]) -> [Offset] {
        offsets.filter { [.born, .alive].contains(self[$0.row, $0.col]) }
    }
    
    var contents: [[Int]] {
        living(allOffsets)
            .map { [$0.row, $0.col] }
            .sorted { $0[0] == $1[0] ? $0[1] > $1[1] : $0[0] > $1[0] }
    }
}

extension Grid {
    func configuration(title: String) throws -> Grid.Configuration {
        try Grid.Configuration(title: title, contents: contents)
    }
}


//
//  Grid.swift
//  
extension Grid {
    public struct History: Equatable, Codable {
        public private(set) var history: [Int: Int]
        public private(set) var cycleLength: Int?

        public init(
            history: [Int: Int] = [:],
            cycleLength: Int? = .none
        ) {
            self.history = history
            self.cycleLength = cycleLength
        }

        public mutating func add(_ grid: Grid) {
            let hash = grid.hashValue
            if let cycle = history[hash] {
                cycleLength = cycle
                return
            }
            history = history.mapValues { $0 + 1 }
            history[hash] = 1
            return
        }

        public mutating func reset(with grid: Grid) {
            history = [Int: Int]()
            cycleLength = .none
            history[grid.hashValue] = 1
        }
    }
}

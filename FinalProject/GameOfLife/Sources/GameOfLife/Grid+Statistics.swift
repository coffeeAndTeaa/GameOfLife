//
//  Grid+Statistics.swift
//  SwiftUIGameOfLife
//
public extension Grid {
    func count(_ state: CellState) -> Int {
        count([state])
    }

    func count(_ states: [CellState]) -> Int {
        count(states, in: allOffsets)
    }
}

public extension Grid {
    struct Statistics: Equatable, Codable {
        public let steps: Int
        public let alive: Int
        public let born:  Int
        public let died:  Int
        public let empty: Int
        
        public init(steps: Int = 0, alive: Int = 0, born: Int = 0, died: Int = 0, empty: Int = 0) {
            self.steps = steps
            self.alive = alive
            self.born = born
            self.died = died
            self.empty = empty
        }
        
        public func add(_ grid: Grid) -> Statistics {
            Statistics(
                steps: steps + 1,
                alive: alive + grid.count(.alive),
                born:  born  + grid.count(.born),
                died:  died  + grid.count(.died),
                empty: empty + grid.count(.empty)
            )
        }
    }
}

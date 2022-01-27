//
//  Statistics.swift
//  SwiftUIGameOfLife
//
import ComposableArchitecture
import GameOfLife

public struct StatisticsState {
    public var statistics: Grid.Statistics = Grid.Statistics.init()

    public init(statistics: Grid.Statistics = Grid.Statistics.init()) {
        self.statistics = statistics
    }
}

extension StatisticsState: Equatable { }
extension StatisticsState: Codable { }

public extension StatisticsState {
    enum Action {
        case update(grid: Grid)
        case reset
    }
}

public let statisticsReducer = Reducer<StatisticsState, StatisticsState.Action, StatisticsEnvironment> { state, action, env in
    switch action {
    case .update(grid: let grid):
        state.statistics = state.statistics.add(grid)
        return .none
    case .reset:
        state.statistics = Grid.Statistics.init()
        return .none
    }
}

public struct StatisticsEnvironment {
    public init() { }
}

public struct StatisticsTestEnvironment {
    public init() { }
}

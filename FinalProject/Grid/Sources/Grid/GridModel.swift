//
//  GridModel.swift
//  SwiftUIGameOfLife
//
import ComposableArchitecture
import Combine
import GameOfLife
import Foundation

public struct GridState {
    public var grid: Grid 
    public var history: Grid.History

    public init(
        grid: Grid = Grid(10, 10, Grid.Initializers.empty),
        history: Grid.History = Grid.History()
    ) {
        self.grid = grid
        self.history = history
        self.history.add(grid)
    }
}

extension GridState: Equatable { }

extension GridState: Codable { }

public extension GridState {
    enum Action {
        case set(grid: Grid)
        case toggle(Int, Int)
    }
}

public let gridReducer = Reducer<GridState, GridState.Action, GridEnvironment> { state, action, env in
    switch action {
        case let .set(grid: grid):
            state.grid = grid
            return .none
        case .toggle(let row, let col):
            state.grid[row, col] = state.grid[row, col].isAlive ? .died : .born
            return .none
    }
}

public struct GridEnvironment {
    public init() { }
}

public struct GridTestEnvironment {
    public init() { }
}

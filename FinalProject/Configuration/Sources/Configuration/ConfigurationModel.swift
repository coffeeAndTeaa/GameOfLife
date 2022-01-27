//
//  ConfigurationModel.swift
//  SwiftUIGameOfLife
//
import ComposableArchitecture
import Grid
import GameOfLife

public struct ConfigurationState {
    public var configuration: Grid.Configuration
    public var gridState: GridState
    public var index: Int

    public init(configuration: Grid.Configuration) {
        self.configuration = configuration
        self.gridState = GridState(
            grid: configuration.maxRow > 50 || configuration.maxCol > 50
                ? configuration.smallGrid
                : configuration.defaultGrid
        )
        self.index = 0
    }

    public init(configuration: Grid.Configuration, gridState: GridState = GridState(), index: Int) {
        self.configuration = configuration
        self.gridState = gridState
        self.index = index
    }
}

extension ConfigurationState {
    public enum Action {
        case grid(action: GridState.Action)
        case simulate(Grid)
    }
}

extension ConfigurationState: Equatable, Identifiable {
    public var id: UUID {
        configuration.id
    }
}

extension ConfigurationState: Codable { }

public struct ConfigurationEnvironment {
    var scheduler: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
    var gridEnvironment = GridEnvironment()

    public init(
        scheduler: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler(),
        gridEnvironment: GridEnvironment = GridEnvironment()
    ) {
        self.scheduler = scheduler
        self.gridEnvironment = gridEnvironment
    }
}

public struct ConfigurationTestEnvironment {
    public init() { }
}

public let configurationReducer = Reducer<ConfigurationState, ConfigurationState.Action, ConfigurationEnvironment>.combine(
    gridReducer.pullback(
        state: \.gridState,
        action: /ConfigurationState.Action.grid(action:),
        environment: \.gridEnvironment
    ),
    Reducer<ConfigurationState, ConfigurationState.Action, ConfigurationEnvironment>{ state, action, env in
        switch action {
            default:
                return .none
        }
    }
)


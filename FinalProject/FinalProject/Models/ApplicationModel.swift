//
//  Application.swift
//  SwiftUIGameOfLife
//

import ComposableArchitecture
import Combine
import Simulation
import Configurations
import Configuration
import Statistics
import Foundation
import GameOfLife

struct AppState: Equatable {
    var selectedTab = Tab.simulation
    var simulationState = SimulationState()
    var configurationState = ConfigurationsState()
    var statisticsState = StatisticsState()
}

extension AppState {
    enum Tab {
        case simulation
        case configuration
        case statistics
    }
}

extension AppState {
    enum Action {
        case setSelectedTab(tab: Tab)
        case simulationAction(action: SimulationState.Action)
        case configurationsAction(action: ConfigurationsState.Action)
        case statisticsAction(action: StatisticsState.Action)
    }
}

struct AppEnvironment {
    var simulationEnvironment = SimulationEnvironment()
    var configurationsEnvironment = ConfigurationsEnvironment()
    var statisticsEnvironment = StatisticsEnvironment()
}

let configurationToSimulationReducer = Reducer<AppState, ConfigurationsState.Action, AppEnvironment> { state, action, env in
    switch action {
        case let .configuration(id: id, action: configAction):
            switch configAction {
                case .simulate(let grid):
                    state.simulationState.gridState.grid = grid
                default:
                    ()
            }
            return .none
        default:
            return .none
    }
}

let _appReducer = Reducer<AppState, AppState.Action, AppEnvironment>.combine(
    // swiftlint:disable trailing_closure
    /// Submodel reducers
    simulationReducer.pullback(
        state: \.simulationState,
        action: /AppState.Action.simulationAction,
        environment: \.simulationEnvironment
    ),
    configurationsReducer.pullback(
        state: \.configurationState,
        action: /AppState.Action.configurationsAction,
        environment: \.configurationsEnvironment
    ),
    statisticsReducer.pullback(
        state: \.statisticsState,
        action: /AppState.Action.statisticsAction,
        environment: \.statisticsEnvironment
    ),
    configurationToSimulationReducer.pullback(
        state: \.self,
        action: /AppState.Action.configurationsAction(action:),
        environment: identity
    ),
    /// Main reducer
    Reducer { state, action, env in
        switch action {
            case .setSelectedTab(let tab):
                state.selectedTab = tab
            case .simulationAction(action: .tick):
                state.statisticsState = StatisticsState(
                    statistics: state.statisticsState.statistics.add(
                        state.simulationState.gridState.grid
                    )
                )
                return .none
            case .simulationAction(action: .resetGridToRandom), .simulationAction(action: .resetGridToEmpty):
                return Just(AppState.Action.statisticsAction(action: .reset)).eraseToEffect()
            default:
                ()
        }
        return .none
    }
)

var appReducer: Reducer<AppState, AppState.Action, AppEnvironment> {
//    #if DEBUG
//    return _appReducer.debug()
//    #else
    return _appReducer
//    #endif
}

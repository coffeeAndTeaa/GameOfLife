//
//  ContentView.swift
//  SwiftUIGameOfLife
//
//  Created by Van Simmons on 5/31/20.
//  Copyright © 2020 ComputeCycles, LLC. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Simulation
import Configurations
import Statistics

struct ContentView: View {
    var store: Store<AppState, AppState.Action>
 
    var body: some View {
        WithViewStore(store) { viewStore in
            TabView(selection: viewStore.binding(
                get: \.selectedTab,
                send: AppState.Action.setSelectedTab(tab:)
            )) {
                self.simulationView()
                    .tag(AppState.Tab.simulation)
                self.configurationsView()
                    .tag(AppState.Tab.configuration)
                self.statisticsView()
                    .tag(AppState.Tab.statistics)
            }
            .accentColor(Color("accent"))
        }
    }

    private func simulationView() -> some View {
        SimulationView(
            store: self.store.scope(
                state: \.simulationState,
                action: AppState.Action.simulationAction(action:)
            )
        )
        .tabItem {
            Image(systemName: "grid.circle.fill")
            Text("Simulation")
        }
    }

    private func configurationsView() -> some View {
        ConfigurationsView(
            store: self.store.scope(
                state: \.configurationState,
                action: AppState.Action.configurationAction(action:)
            )
        )
        .tabItem {
            Image(systemName: "magnifyingglass")
            Text("Configuration")
        }
    }

    private func statisticsView() -> some View {
        StatisticsView(
            store: store.scope(
                state: \.statisticsState,
                action: AppState.Action.statisticsAction(action:)
            )
        )
       .tabItem {
            Image(systemName: "eyeglasses")
            Text("Statistics")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let previewState = AppState()
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: previewState,
                reducer: appReducer,
                environment: AppEnvironment()
            )
        )
    }
}

//
//  GridEditorView.swift
//  GameOfLife
//

import Foundation
import SwiftUI
import ComposableArchitecture
import GameOfLife
import Grid
import Theming


private func shorten(to g: GeometryProxy, by: CGFloat = 0.92) -> CGFloat {
    min(min(g.size.width, g.size.height) * by, g.size.height - 120.0)
}

struct GridEditorView: View {
    var store: Store<ConfigurationState, ConfigurationState.Action>
    @ObservedObject var viewStore: ViewStore<ConfigurationState, ConfigurationState.Action>

    init(store: Store<ConfigurationState, ConfigurationState.Action>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }

    var body: some View {
        VStack {
            Spacer()
            // Problem 4A - your code goes here
            GridView(
                store:
                        self.store.scope(
                            state: \.gridState,
                            action: ConfigurationState.Action.grid(action: )
                ),
                fractionComplete: CGFloat(1.0)
            )
            self.themedButton
            Spacer()
        }
        .navigationBarTitle(self.viewStore.configuration.title)
        .navigationBarHidden(false)
        .frame(alignment: .center)
    }
}

// MARK: Subviews
extension GridEditorView {
    var themedButton: some View {
        WithViewStore(store) { viewStore in
            ThemedButton(text: "Simulate") {
                // Problem 4B - your code goes here
                viewStore.send(.simulate(viewStore.gridState.grid))
            }
        }
    }
}

public struct GridEditorView_Previews: PreviewProvider {
    static let grid = Grid(10, 10, Grid.Initializers.random)
    static let previewState = ConfigurationState(
        configuration: try! .init(title: "Example", contents: grid.contents),
        gridState: GridState(grid: grid),
        index: 0
    )
    public static var previews: some View {
        GeometryReader { g in
            GridEditorView(
                store: Store(
                    initialState: previewState,
                    reducer: configurationReducer,
                    environment: ConfigurationEnvironment()
                )
            )
        }
    }
}

//
//  StatisticsView.swift
//  SwiftUIGameOfLife
//
import SwiftUI
import ComposableArchitecture
import Theming

public struct StatisticsView: View {
    let store: Store<StatisticsState, StatisticsState.Action>
    let viewStore: ViewStore<StatisticsState, StatisticsState.Action>

    public init(store: Store<StatisticsState, StatisticsState.Action>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                Form {
                    // Your Problem 7A code starts here
                    FormLine(title: "Steps", value: self.viewStore.state.statistics.steps)
                    FormLine(title: "Alive", value: self.viewStore.state.statistics.alive)
                    FormLine(title: "Born", value: self.viewStore.state.statistics.born)
                    FormLine(title: "Died", value: self.viewStore.state.statistics.died)
                    FormLine(title: "Empty", value: self.viewStore.state.statistics.empty)
                    ThemedButton(text: "Reset") {
                        self.viewStore.send(.reset)
                    }
                    .frame(alignment: .center)
                }
                .padding()
            }
            .navigationBarTitle(Text("Statistics"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

public struct StatisticsView_Previews: PreviewProvider {
    static let previewState = StatisticsState()
    public static var previews: some View {
        StatisticsView(
            store: Store(
                initialState: previewState,
                reducer: statisticsReducer,
                environment: StatisticsEnvironment()
            )
        )
    }
}

//
//  CounterView.swift
//  FinalProject
//
import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: Store<CounterState, CounterAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Button("−") { viewStore.send(.decrementButtonTapped) }
                Text("\(viewStore.count)")
                    .font(Font.title.monospacedDigit())
                Button("+") { viewStore.send(.incrementButtonTapped) }
            }
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(
            store: Store<CounterState, CounterAction>(
                initialState: CounterState(count: 10),
                reducer: counterReducer,
                environment: CounterEnvironment()
            )
        )
    }
}

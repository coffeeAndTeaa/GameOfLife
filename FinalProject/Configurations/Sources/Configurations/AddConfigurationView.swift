//
//  AddConfigurationView.swift
//  FinalProject
//

import SwiftUI
import ComposableArchitecture
import Combine
import Theming

struct AddConfigurationView: View {
    var store: Store<AddConfigState, AddConfigState.Action>
    @ObservedObject var viewStore: ViewStore<AddConfigState, AddConfigState.Action>
    @State private var keyboardHeight: CGFloat = 0

    init(store: Store<AddConfigState, AddConfigState.Action>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    var body: some View {
        GeometryReader { proxy in
            VStack {
//                Spacer()
                VStack {
                    //Problem 5C Goes inside the following HStacks...
                    HStack {
                        TextField("title",
                                  text: self.viewStore.binding(
                                    get: \.title,
                                    send: {AddConfigState.Action.updateTitle($0)})
                                )
                    }
                    HStack {
                        Text("Size:")
                            .foregroundColor(Color.gray)
                            .padding(.trailing, 8.0)
                            .frame(width: proxy.size.width * 0.2, alignment: .trailing)
                        CounterView(store: self.store.scope(state: \.counterState, action: AddConfigState.Action.counterStateAction(action: )))
                    }
                }
                .padding()
                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2.0))
                .frame(width: proxy.size.width , height: proxy.size.height , alignment: .center)
//                .padding(.bottom, 24.0)

                HStack {
                    Spacer()
                    // Problem 5D - your answer goes in the following buttons
                    ThemedButton(text: "Save") {
                        viewStore.send(.ok)
                    }
                    ThemedButton(text: "Cancel") {
                        viewStore.send(.cancel)
                    }
                    Spacer()
                }
//                Spacer()
            }
            .font(.title)
            .frame(width: proxy.size.width , height: proxy.size.width, alignment: .center)
        }.frame(alignment: .center)
    }
}

struct AddConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        AddConfigurationView(
            store: Store<AddConfigState, AddConfigState.Action>(
                initialState: AddConfigState(
                    title: "",
                    counterState: CounterState(count: 10)
                ),
                reducer: addConfigReducer,
                environment: AddConfigEnvironment()
            )
        )
    }
}

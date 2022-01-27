//
//  AddConfigsModel.swift
//  
//
import ComposableArchitecture

public struct AddConfigState: Equatable, Codable {
    public var title: String
    public var counterState: CounterState

    public init(title: String = "", counterState: CounterState = CounterState()) {
        self.title = title
        self.counterState = counterState
    }
}

public extension AddConfigState {
    enum Action: Equatable {
        case updateTitle(String)
        case cancel
        case ok
        case counterStateAction(action: CounterAction)
    }
}

public struct AddConfigEnvironment {
    public var counterEnvironment = CounterEnvironment()
    public init() { }
}

public let addConfigReducer = Reducer<AddConfigState, AddConfigState.Action, AddConfigEnvironment>.combine(
    counterReducer.pullback(
        state: \.counterState,
        action: /AddConfigState.Action.counterStateAction(action:),
        environment: \.counterEnvironment
    ),
    Reducer<AddConfigState, AddConfigState.Action, AddConfigEnvironment> { state, action, _ in
        switch action {
            case .updateTitle(let title):
                state.title = title
                return .none
            case .cancel:
                return .none
            case .ok:
                return .none
            case .counterStateAction(action:):
                return .none
        }
    }
)


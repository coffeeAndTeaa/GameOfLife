//
//  CounterModel.swift
//  
//
import ComposableArchitecture

public struct CounterState: Equatable, Codable {
    public var count: Int
    public init(count: Int = 10) {
        self.count = count
    }
}

public enum CounterAction: Equatable {
  case decrementButtonTapped
  case incrementButtonTapped
}

public struct CounterEnvironment {
    public init() { }
}

public let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, _ in
    switch action {
        case .decrementButtonTapped:
            state.count -= 1
            return .none
        case .incrementButtonTapped:
            state.count += 1
            return .none
    }
}

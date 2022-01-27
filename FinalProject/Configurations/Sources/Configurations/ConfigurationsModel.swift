//
//  Configuration.swift
//  SwiftUIGameOfLife
//
import Foundation
import ComposableArchitecture
import Combine
import Dispatch
import GameOfLife
import Configuration

// MARK: API Support
private let configURL = URL(string: "https://www.dropbox.com/s/i4gp5ih4tfq3bve/S65g.json?dl=1")!

enum APIError: Error {
    case urlError(URL, URLError)
    case badResponse(URL, URLResponse)
    case badResponseStatus(URL, HTTPURLResponse)
    case jsonDecodingError(URL, Error, String)
}

class DefaultHandlingSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        completionHandler(.performDefaultHandling, .none)
    }
}

// MARK: ConfigurationsState
public struct ConfigurationsState {
    public var configs: IdentifiedArrayOf<ConfigurationState> = []
    public var isFetching = false
    public var isAdding = false
    public var addConfigState: AddConfigState

    public init(
        configs: IdentifiedArrayOf<ConfigurationState> = [],
        addConfigsState: AddConfigState = AddConfigState()
    ) {
        self.configs = configs
        self.addConfigState = addConfigsState
    }

    static var session: URLSession {
        URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: DefaultHandlingSessionDelegate(),
            delegateQueue: .none
        )
    }

    static func validateHttpResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badResponse(configURL, response)
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError.badResponseStatus(configURL, httpResponse)
        }
        return data
    }
}

extension ConfigurationsState: Equatable { }
extension ConfigurationsState: Codable { }

public extension ConfigurationsState {
    enum Action {
        case setConfigs([ConfigurationState])
        case add
        case stopAdding(Bool)
        case fetch
        case cancelFetch
        case clear
        case select(row: Int?)
        case configuration(id: UUID, action: ConfigurationState.Action)
        case addConfigAction(action: AddConfigState.Action)
    }
    
    enum Identifiers: Hashable, CaseIterable {
        case fetchCancellable
    }
}

public struct ConfigurationsEnvironment {
    public private(set) var configurationEnvironment = ConfigurationEnvironment()
    public private(set) var addConfigEnvironment = AddConfigEnvironment()

    public init(
        configurationEnvironment: ConfigurationEnvironment = ConfigurationEnvironment(),
        addConfigEnvironment: AddConfigEnvironment = AddConfigEnvironment()
    ) {
        self.configurationEnvironment = configurationEnvironment
        self.addConfigEnvironment = addConfigEnvironment
    }
}

public let configurationsReducer = Reducer<ConfigurationsState, ConfigurationsState.Action, ConfigurationsEnvironment>.combine(
    addConfigReducer.pullback(
        state: \.addConfigState,
        action: /ConfigurationsState.Action.addConfigAction(action:),
        environment: \.addConfigEnvironment
    ),
    configurationReducer.forEach(
        state: \ConfigurationsState.configs,
        action: /ConfigurationsState.Action.configuration(id:action:),
        environment: \.configurationEnvironment
    ),
    Reducer<ConfigurationsState, ConfigurationsState.Action, ConfigurationsEnvironment> { state, action, env in
        switch action {
            case .add:
                state.isAdding = true
                return .none
            case .stopAdding:
                state.isAdding = false
                return .none
            case .setConfigs(let configs):
                state.configs = IdentifiedArrayOf(uniqueElements: configs)
                return .none
            case .fetch:
                state.isFetching = true
                state.configs = []
                return URLSession
                    .DataTaskPublisher(request: URLRequest(url: configURL), session: ConfigurationsState.session)
                    .mapError { APIError.urlError(configURL, $0) }
                    .tryMap (ConfigurationsState.validateHttpResponse)
                    .mapError { $0 as! APIError }
                    .decode(type: [Grid.Configuration].self, decoder: JSONDecoder())
                    .replaceError(with: [])
                    .receive(on: DispatchQueue.main)
                    .map { .setConfigs($0.map(ConfigurationState.init)) }
                    .eraseToEffect()
                    .cancellable( id: ConfigurationsState.Identifiers.fetchCancellable)
            case .cancelFetch:
                state.isFetching = false
                return .cancel(id: ConfigurationsState.Identifiers.fetchCancellable)
            case .clear:
                state.isFetching = false
                state.configs = []
                return .cancel(id: ConfigurationsState.Identifiers.fetchCancellable)
            case .select(row: let row):
                return .none
            case let .configuration(id: id, action: action):
                return .none
            case .addConfigAction(action: let addConfigAction):
                switch addConfigAction {
                    case .ok:
                        do {
                            let newConfig = try Grid.Configuration(
                                title: state.addConfigState.title,
                                contents: [
                                    [
                                        state.addConfigState.counterState.count - 1,
                                        state.addConfigState.counterState.count - 1
                                    ]
                                ]
                            )
                            state.configs.append(ConfigurationState(configuration: newConfig))
                        } catch { }
                        state.isAdding = false
                    case .cancel:
                        state.isAdding = false
                    case .updateTitle, .counterStateAction(action:):
                        ()
                }
                return .none
        }
    }
)

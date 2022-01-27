//
//  SwiftUIGameOfLifeApp.swift
//  FinalProject
//

import Foundation
import SwiftUI
import ComposableArchitecture

@main
struct SwiftUIGameOfLife: App {
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor.clear
                UINavigationBar.appearance().isTranslucent = true
                UINavigationBar.appearance().titleTextAttributes = [
                    .foregroundColor: UIColor(named: "accent")!
                ]
                UINavigationBar.appearance().largeTitleTextAttributes = [
                    .foregroundColor: UIColor(named: "accent")!
                ]
                UINavigationBar.appearance().tintColor = UIColor(named: "accent")
                UINavigationBar.appearance().barTintColor = UIColor(named: "accent")
    }
    let store = Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}

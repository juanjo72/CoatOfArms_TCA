//
//  CoatOfArms_TCAApp.swift
//  CoatOfArms_TCA
//
//  Created on 30/9/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@main
struct CoatOfArms_TCAApp: App {
    let store: StoreOf<GameFeature> = {
        Store(
            initialState: GameFeature.State(id: .now),
            reducer: {
                GameFeature()
            }
        )
    }()

    var body: some Scene {
        WindowGroup {
            GameView(
                store: store
            )
            .onAppear {
                store.send(.viewWillAppear)
            }
        }
    }
}

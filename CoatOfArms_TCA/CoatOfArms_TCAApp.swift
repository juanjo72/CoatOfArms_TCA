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
    let store: StoreOf<AppFeature> = {
        Store(
            initialState: AppFeature.State.idle,
            reducer: {
                AppFeature()
            }
        )
    }()

    var body: some Scene {
        WindowGroup {
            VStack {
                switch store.state {
                case .idle:
                    Spacer()
                case .playing:
                    if let childStore = store.scope(state: \.playing, action: \.playing) {
                        GameView(store: childStore)
                    }
                case .gameOver:
                    Text("Game Over")
                }
            }
            .onAppear {
                store.send(.viewWillAppear)
            }
        }
    }
}

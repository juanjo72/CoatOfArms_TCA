//
//  AppView.swift
//  CoatOfArms_TCA
//
//  Created on 7/10/24.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    static var store: StoreOf<AppFeature> = {
        Store(
            initialState: AppFeature.State.idle,
            reducer: {
                AppFeature()
            }
        )
    }()
    
    var body: some View {
        ZStack {
            switch Self.store.state {
            case .idle:
                Spacer()

            case .playing:
                if let childStore = Self.store.scope(state: \.playing, action: \.playing) {
                    GameView(store: childStore)
                }

            case .gameOver:
                if let childStore = Self.store.scope(state: \.gameOver, action: \.gameOver) {
                    GameOverView(store: childStore)
                }
            }
        }
        .onAppear {
            Self.store.send(.viewWillAppear)
        }
    }
}

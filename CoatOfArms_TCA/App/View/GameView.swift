//
//  GameView.swift
//  CoatOfArms_TCA
//
//  Created on 6/10/24.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: GameFeature.self)
struct GameView: View {
    let store: StoreOf<GameFeature>
    let style: Style

    var body: some View {
        VStack(
            spacing: 30
        ) {
            if let childStore = store.scope(state: \.question, action: \.question) {
                QuestionView(store: childStore)
                    .id(childStore.state.id)
            }
            
            if let childStore = store.scope(state: \.livesCount, action: \.livesCount) {
                LivesCountView(store: childStore, style: style.remaininLives)
                    .id(childStore.state.id)
            }
        }
        .padding()
        .onAppear {
            send(.onAppear)
        }
    }
}

extension GameView {
    struct Style {
        let remaininLives: LivesCountView.Style
    }
}

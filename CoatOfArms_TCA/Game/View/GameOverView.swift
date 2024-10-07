//
//  GameOverView.swift
//  CoatOfArms
//
//  Created on 31/8/24.
//

import ComposableArchitecture
import SwiftUI

struct GameOverView: View {
    let store: StoreOf<GameOverFeature>
    
    // MARK: View

    var body: some View {
        VStack(
            spacing: 20
        ) {
            Text("Game Over")
                .font(.headline)

            Text("Score: \(store.score)")
                .font(.subheadline)

            Button(
                action: {
                    store.send(.userDidTapRestartButton)
                },
                label: {
                    Text("Again")
                        .padding(.horizontal)
                }
            )
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
        .onAppear {
            store.send(.viewWillAppear)
        }
    }
}

#Preview {
    GameOverView(
        store: Store(
            initialState: GameOverFeature.State(game: .now),
            reducer: {
                GameOverFeature()
            }
        )
    )
}

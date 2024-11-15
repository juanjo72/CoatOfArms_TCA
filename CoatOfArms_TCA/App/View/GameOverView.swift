//
//  GameOverView.swift
//  CoatOfArms
//
//  Created on 31/8/24.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: GameOverFeature.self)
struct GameOverView: View {
    let store: StoreOf<GameOverFeature>
    let style: Style

    // MARK: View

    var body: some View {
        VStack(
            spacing: style.vSpacing
        ) {
            Text("Game Over")
                .font(style.heading)

            Text("Score: \(store.score)")
                .font(style.subheadline)

            Button(
                action: {
                    send(.userDidTapRestartButton)
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
            send(.onAppear)
        }
    }
}

extension GameOverView {
    struct Style {
        let heading: Font
        let subheadline: Font
        let vSpacing: CGFloat
    }
}

#Preview {
    GameOverView(
        store: Store(
            initialState: GameOverFeature.State(game: .now),
            reducer: {
                GameOverFeature()
            }
        ),
        style: .default
    )
}

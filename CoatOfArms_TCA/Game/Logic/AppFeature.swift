//
//  AppFeature.swift
//  CoatOfArms_TCA
//
//  Created on 7/10/24.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
    @ObservableState
    enum State: Equatable {
        case idle
        case playing(GameFeature.State)
        case gameOver(GameOverFeature.State)
    }

    enum Action: Equatable {
        case viewWillAppear
        // children's actions
        case playing(GameFeature.Action)
        case gameOver(GameOverFeature.Action)
    }

    @Dependency(\.date) var dateGenerator

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewWillAppear:
                state = .playing(GameFeature.State(id: dateGenerator.now))
                return .none

            case .playing(.gameOver(let gameStamp)):
                state = .gameOver(GameOverFeature.State(game: gameStamp))
                return .none

            case .gameOver(.userDidTapRestartButton):
                state = .playing(GameFeature.State(id: dateGenerator.now))
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.playing, action: \.playing) {
            GameFeature()
        }
        .ifLet(\.gameOver, action: \.gameOver) {
            GameOverFeature()
        }
    }
}

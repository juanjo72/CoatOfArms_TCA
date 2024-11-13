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

    enum Action: Equatable, ViewAction {
        case view(ViewAction)
        case playing(GameFeature.Action)
        case gameOver(GameOverFeature.Action)

        @CasePathable
        enum ViewAction {
            case onAppear
        }
    }

    @Dependency(\.date) var dateGenerator

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                state = .playing(GameFeature.State(id: dateGenerator.now))
                return .none

            case .playing(.delegate(.gameOver(let gameStamp))):
                state = .gameOver(GameOverFeature.State(game: gameStamp))
                return .none

            case .playing:
                return .none
                
            case .gameOver(.delegate(.userDidTapRestartButton)):
                state = .playing(GameFeature.State(id: dateGenerator.now))
                return .none
                
            case .gameOver:
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

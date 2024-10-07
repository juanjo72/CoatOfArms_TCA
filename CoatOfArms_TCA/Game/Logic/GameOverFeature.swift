//
//  GameOverFeature.swift
//  CoatOfArms_TCA
//
//  Created on 7/10/24.
//

import ComposableArchitecture

@Reducer
struct GameOverFeature {
    @ObservableState
    struct State: Equatable {
        let game: GameStamp
        var score: Int = 0
    }

    enum Action: Equatable {
        case viewWillAppear
        case userDidTapRestartButton
        case rightCountUpdate(count: Int)
    }

    @Dependency(\.sourceOfTruth) var sourceOfTruth

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewWillAppear:
                let game = state.game
                return .publisher {
                    sourceOfTruth.getAllElementsObservable(of: UserChoice.self)
                        .map { $0.filter { $0.id.gameStamp == game } }
                        .map { $0.filter { $0.isCorrect } }
                        .map(\.count)
                        .map(Action.rightCountUpdate)
                }
                
            case .rightCountUpdate(let count):
                state.score = count
                return .none

            case .userDidTapRestartButton:
                return .none
            }
        }
    }
}

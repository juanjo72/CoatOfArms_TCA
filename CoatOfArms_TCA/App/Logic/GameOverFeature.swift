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

    enum Action: Equatable, ViewAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case _didUpdateRightChoices(count: Int)

        @CasePathable
        enum ViewAction {
            case onAppear
            case userDidTapRestartButton
        }

        @CasePathable
        enum DelegateAction {
            case userDidTapRestartButton
        }
    }

    @Dependency(\.sourceOfTruth) var sourceOfTruth

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                let game = state.game
                return .publisher {
                    sourceOfTruth.getAllElementsObservable(of: UserChoice.self)
                        .map { $0.filter { $0.id.gameStamp == game } }
                        .map { $0.filter { $0.isCorrect } }
                        .map(\.count)
                        .map(Action._didUpdateRightChoices)
                }
                
            case .view(.userDidTapRestartButton):
                return .run {
                    await $0(.delegate(.userDidTapRestartButton))
                }

            case ._didUpdateRightChoices(let count):
                state.score = count
                return .none

            case .delegate:
                return .none
            }
        }
    }
}

//
//  RemainingLivesFeature.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import ComposableArchitecture

@Reducer
struct RemainingLivesFeature {
    @ObservableState
    struct State: Equatable {
        var remainingLives: Int = 0
        var totalLives: Int = 0
    }
    
    enum Action {
        case viewWillAppear
        case update(numberOfLives: Int)
    }
    
    @Dependency(\.gameSettings) var gameSetting
    @Dependency(\.remainingLivesRepository) var repository
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewWillAppear:
                state.totalLives = gameSetting.maxWrongAnswers
                return .publisher {
                    repository.wrongAnswers
                        .map(\.count)
                        .map { Action.update(numberOfLives: gameSetting.maxWrongAnswers - $0) }
                }
            case .update(let numberOfLives):
                state.remainingLives = numberOfLives
                return .none
            }
        }
    }
}

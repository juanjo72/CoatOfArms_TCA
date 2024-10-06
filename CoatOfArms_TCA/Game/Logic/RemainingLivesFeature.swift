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
        let id: Question.ID
        var remainingLives: Int = 0
        var totalLives: Int = 0
    }
    
    enum Action {
        case viewWillAppear
        case update(numberOfLives: Int)
    }
    
    @Dependency(\.gameSettings) var gameSetting
    @Dependency(\.sourceOfTruth) var sourceOfTruth
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewWillAppear:
                state.totalLives = gameSetting.maxWrongAnswers
                let questionId = state.id
                return .publisher {
                    self.sourceOfTruth.getAllElementsObservable(of: UserChoice.self)
                        .map { $0.filter { $0.id.gameStamp == questionId.gameStamp } }
                        .map { $0.filter { !$0.isCorrect } }
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

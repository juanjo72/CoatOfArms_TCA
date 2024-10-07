//
//  GameFeature.swift
//  CoatOfArms_TCA
//
//  Created on 6/10/24.
//

import ComposableArchitecture

@Reducer
struct GameFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: GameStamp
        var history: [CountryCode] = []
        var question: QuestionFeature.State?
        var remainingLives: RemainingLivesFeature.State?
    }
    
    enum Action: Equatable {
        case viewWillAppear
        case question(QuestionFeature.Action)
        case remainingLives(RemainingLivesFeature.Action)
        case gameOVer
    }
    
    @Dependency(\.randomCountryGenerator) var randomCountryGenerator
    
    var body: some ReducerOf<Self> {
        Reduce() { state, action in
            switch action {
            case .viewWillAppear:
                state.remainingLives = RemainingLivesFeature.State(id: state.id)
                let code = randomCountryGenerator.generateCode(excluding: [])
                let newQuestion = QuestionFeature.State(id: Question.ID(gameStamp: state.id, countryCode: code))
                state.history.append(newQuestion.id.countryCode)
                state.question = newQuestion
                return .none

            case .question(.buttons(.element(id: _, action: .done))):
                let code = randomCountryGenerator.generateCode(excluding: state.history)
                let newQuestion = QuestionFeature.State(id: Question.ID(gameStamp: state.id, countryCode: code))
                state.history.append(newQuestion.id.countryCode)
                state.question = newQuestion
                return .none
                
            case .remainingLives(.update(numberOfLives: let n)):
                if n == 0 {
                    return .send(.gameOVer)
                } else {
                    return .none
                }
                
            case .gameOVer:
                state.question = nil
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.question, action: \.question) {
            QuestionFeature()
        }
        .ifLet(\.remainingLives, action: \.remainingLives) {
            RemainingLivesFeature()
        }
    }
}

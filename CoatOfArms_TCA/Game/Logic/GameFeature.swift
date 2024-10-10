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
        case newQuestion
        case gameOver(GameStamp)
        // children's actions
        case question(QuestionFeature.Action)
        case remainingLives(RemainingLivesFeature.Action)
    }
    
    @Dependency(\.continuousClock) var continuousClock
    @Dependency(\.gameSettings) var gameSettings
    @Dependency(\.randomCountryGenerator) var randomCountryGenerator

    var body: some ReducerOf<Self> {
        Reduce() { state, action in
            switch action {
            case .viewWillAppear:
                state.remainingLives = RemainingLivesFeature.State(id: state.id)
                return .send(.newQuestion)

            case .newQuestion:
                let code = randomCountryGenerator.generateCode(excluding: state.history)
                let newQuestion = QuestionFeature.State(id: Question.ID(gameStamp: state.id, countryCode: code))
                state.history.append(newQuestion.id.countryCode)
                state.question = newQuestion
                return .none

            case .question(.answered(let isGameOver)):
                let game = state.id
                return .run { send in
                    try? await continuousClock.sleep(for: gameSettings.resultTime)
                    await send(isGameOver ? .gameOver(game) : .newQuestion)
                }

            case .question(.emptpyCoatOfArmsError):
                return .send(.newQuestion)

            case .gameOver:
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

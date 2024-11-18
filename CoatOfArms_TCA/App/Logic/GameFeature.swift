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
        var livesCount: LivesCountFeature.State?
        var question: QuestionFeature.State?
    }
    
    enum Action: Equatable, ViewAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case question(QuestionFeature.Action)
        case livesCount(LivesCountFeature.Action)
        case _nextQuestion

        @CasePathable
        enum ViewAction {
            case onAppear
        }

        @CasePathable
        enum DelegateAction: Equatable {
            case gameOver(GameStamp)
        }
    }
    
    @Dependency(\.continuousClock) var continuousClock
    @Dependency(\.gameSettings) var gameSettings
    @Dependency(\.randomCountryGenerator) var randomCountryGenerator
    @Dependency(\.sourceOfTruth) var sourceOfTruth

    var body: some ReducerOf<Self> {
        Reduce() { state, action in
            switch action {
            case .view(.onAppear):
                state.livesCount = LivesCountFeature.State(id: state.id)
                return .send(._nextQuestion)

            case .question(.delegate(.didAnswer)):
                let game = state.id
                return .run { send in
                    try? await continuousClock.sleep(for: gameSettings.resultTime)

                    let wrongCount = await sourceOfTruth.getAllElements(of: UserChoice.self)
                        .filter { $0.id.gameStamp == game }
                        .filter { !$0.isCorrect }
                        .count
                    let isGameOver = (gameSettings.maxWrongAnswers - wrongCount == 0)
                    await send(isGameOver ? .delegate(.gameOver(game)) : ._nextQuestion)
                }

            case .question(.delegate(.emptyCoatOfArmsError)):
                return .send(._nextQuestion)

            case .question:
                return .none

            case .delegate:
                return .none

            case .livesCount:
                return .none

            case ._nextQuestion:
                let code = randomCountryGenerator.generateCode(excluding: state.history)
                let newQuestion = QuestionFeature.State(id: Question.ID(gameStamp: state.id, countryCode: code))
                state.history.append(newQuestion.id.countryCode)
                state.question = newQuestion
                return .none
            }
        }
        .ifLet(\.question, action: \.question) {
            QuestionFeature()
        }
        .ifLet(\.livesCount, action: \.livesCount) {
            LivesCountFeature()
        }
    }
}

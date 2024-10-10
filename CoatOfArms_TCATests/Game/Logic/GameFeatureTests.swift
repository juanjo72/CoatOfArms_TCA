//
//  GameFeature.swift
//  CoatOfArms_TCA
//
//  Created on 10/10/24.
//

@testable import CoatOfArms_TCA
import ComposableArchitecture
import Foundation
import Testing

@Suite("GameFeatureTests", .tags(.logicLayer)) @MainActor
struct GameFeatureTests {
    @Test("Initial state")
    func test_WhenViewWillAppear_ThenRemainingLivesAndFirstQuestionAreCreated() async {
        // Given
        let date = Date(timeIntervalSince1970: 0)
        let randomCountryGenerator = RandomCountryCodeProviderProtocolMock()
        randomCountryGenerator.generateCodeExcludingReturnValue = "ES"
        let store = TestStore(
            initialState: GameFeature.State(id: date),
            reducer: {
                GameFeature()
            },
            withDependencies: { values in
                values.randomCountryGenerator = randomCountryGenerator
            }
        )

        // When
        await store.send(GameFeature.Action.viewWillAppear) {
            // Then
            $0.remainingLives = RemainingLivesFeature.State(id: date)
        }
        await store.receive(GameFeature.Action.newQuestion) {
            // Then
            $0.history = ["ES"]
            $0.question = QuestionFeature.State(id: Question.ID(gameStamp: date, countryCode: "ES"))
        }
    }

    @Test("Answer with no game over")
    func test_WhenAnswerBubbleUpsWithGameOver_ThenNewQuestionIsReceived() async {
        // Given
        let date = Date.distantFuture
        let initialState = GameFeature.State(
            id: date,
            question: QuestionFeature.State(id: Question.ID(gameStamp: date, countryCode: "ES")),
            remainingLives: RemainingLivesFeature.State(id: date)
        )
        let store = TestStore(
            initialState: initialState,
            reducer: {
                GameFeature()
            },
            withDependencies: { values in
                values.continuousClock = ImmediateClock()
            }
        )
        store.exhaustivity = .off

        // When
        await store.send(GameFeature.Action.question(.answered(isGameOver: false)))

        // Then
        await store.receive(.newQuestion)
    }

    @Test("Answer with game over")
    func test_WhenAnswerBubbleUpsWithGameOver_ThenGameOverActionIsReveived() async {
        // Given
        let date = Date.distantFuture
        let initialState = GameFeature.State(
            id: date,
            question: QuestionFeature.State(id: Question.ID(gameStamp: date, countryCode: "ES")),
            remainingLives: RemainingLivesFeature.State(id: date)
        )
        let store = TestStore(
            initialState: initialState,
            reducer: {
                GameFeature()
            },
            withDependencies: { values in
                values.continuousClock = ImmediateClock()
            }
        )

        // When
        await store.send(GameFeature.Action.question(.answered(isGameOver: true)))

        // Then
        await store.receive(GameFeature.Action.gameOver(date))
    }

    @Test("Country with coat of arms error")
    func test_WhenMissingImageURL_ThenANewQuestionIsAsked() async {
        // Given
        let date = Date.distantFuture
        let initialState = GameFeature.State(
            id: date,
            question: QuestionFeature.State(id: Question.ID(gameStamp: date, countryCode: "ES")),
            remainingLives: RemainingLivesFeature.State(id: date)
        )
        let store = TestStore(
            initialState: initialState,
            reducer: {
                GameFeature()
            },
            withDependencies: { values in
                values.continuousClock = ImmediateClock()
            }
        )
        store.exhaustivity = .off

        // When
        await store.send(.question(.emptpyCoatOfArmsError))

        // Then
        await store.receive(.newQuestion)
    }
}

//
//  GameFeature.swift
//  CoatOfArms_TCA
//
//  Created on 10/10/24.
//

import Combine
@testable import CoatOfArms_TCA
import ComposableArchitecture
import Foundation
import Testing

@Suite("GameFeatureTests", .tags(.logicLayer)) @MainActor
struct GameFeatureTests {
    @Test("onAppear")
    func testOnAppear() async {
        let date = Date.distantPast
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

        await store.send(\.view.onAppear) {
            $0.livesCount = LivesCountFeature.State(id: date)
        }
        await store.receive(._nextQuestion) {
            $0.history = ["ES"]
            $0.question = QuestionFeature.State(id: Question.ID(gameStamp: date, countryCode: "ES"))
        }
    }

    @Test("Game over")
    func testGameOver() async {
        let date = Date.distantFuture
        let sourceOfTruth = StorageProtocolMock()
        sourceOfTruth.getAllElementsOfReturnValue = [
            UserChoice.make(game: Date.distantFuture, countryCode: "RU", pickedCountryCode: "ES"),
            UserChoice.make(game: Date.distantFuture, countryCode: "IT", pickedCountryCode: "FR"),
            UserChoice.make(game: Date.distantFuture, countryCode: "FR", pickedCountryCode: "US"),
        ]
        let initialState = GameFeature.State(
            id: date,
            livesCount: LivesCountFeature.State(id: date),
            question: QuestionFeature.State(id: Question.ID(gameStamp: date, countryCode: "ES"))
        )
        let store = TestStore(
            initialState: initialState,
            reducer: {
                GameFeature()
            },
            withDependencies: {
                $0.continuousClock = ImmediateClock()
                $0.sourceOfTruth = sourceOfTruth
            }
        )

        await store.send(.question(.delegate(.didAnswer)))
        await store.receive(.delegate(.gameOver(date)))
    }

    @Test("Country with coat of arms error")
    func testMissingImageURL() async {
        // Given
        let date = Date.distantFuture
        let initialState = GameFeature.State(
            id: date,
            livesCount: LivesCountFeature.State(id: date),
            question: QuestionFeature.State(id: Question.ID(gameStamp: date, countryCode: "ES"))
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
        await store.send(.question(.delegate(.emptyCoatOfArmsError)))

        // Then
        await store.receive(._nextQuestion)
    }
}

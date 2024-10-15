//
//  GameOverFeatureTests.swift
//  CoatOfArms_TCA
//
//  Created on 15/10/24.
//

@testable import CoatOfArms_TCA
import Combine
import ComposableArchitecture
import Foundation
import Testing

@Suite("GameOverFeature", .tags(.logicLayer)) @MainActor
struct GameOverFeatureTests {
    @Test("Score zero")
    func test_GivenNoRightAnswers_WhenAppear_ThenScoreRemainZero() async {
        // Given
        let store = TestStore(
            initialState: GameOverFeature.State(
                game: Date.distantFuture
            ),
            reducer: { GameOverFeature() }
        )

        // When
        let task = await store.send(.viewWillAppear)

        // Then
        await store.receive(.rightCountUpdate(count: 0))
        await task.cancel()
    }

    @Test("Score greater than zero")
    func test_GivenRightAnswers_WhenAppear_ThenScoreIsChanged() async {
        // Given
        let game = Date.distantFuture
        let sourceOfTruth = StorageProtocolMock()
        sourceOfTruth.getAllElementsObservableOfReturnValue = Just<[UserChoice]>(
            [
                UserChoice.make(game: Date.distantPast, countryCode: "RU", pickedCountryCode: "RU"),
                UserChoice.make(game: game, countryCode: "IT", pickedCountryCode: "FR"),
                UserChoice.make(game: game, countryCode: "ES", pickedCountryCode: "ES"),
                UserChoice.make(game: game, countryCode: "FR", pickedCountryCode: "FR"),
            ]
        ).eraseToAnyPublisher()
        let store = TestStore(
            initialState: GameOverFeature.State(
                game: game
            ),
            reducer: { GameOverFeature() },
            withDependencies: {
                $0.sourceOfTruth = sourceOfTruth
            }
        )

        // When
        let task = await store.send(.viewWillAppear)

        // Then
        await store.receive(/GameOverFeature.Action.rightCountUpdate) {
            $0.score = 2
        }
        await task.cancel()
    }

    @Test("Restart button")
    func test_WhenTapRestartButton_ThenStateIsNotChanged() async {
        // Given
        let store = TestStore(
            initialState: GameOverFeature.State(
                game: Date.distantFuture
            ),
            reducer: { GameOverFeature() }
        )

        // When
        // Then
        await store.send(.userDidTapRestartButton)
    }
}

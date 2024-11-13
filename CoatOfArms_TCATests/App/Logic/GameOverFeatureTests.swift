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
    @Test("onAppear")
    func testOnAppear() async {
        let game = Date.now
        let sourceOfTruth = StorageProtocolMock()
        let publisher = CurrentValueSubject<[UserChoice], Never>(
            [
                UserChoice.make(game: Date.distantPast, countryCode: "RU", pickedCountryCode: "RU"),
            ]
        )
        sourceOfTruth.getAllElementsObservableOfReturnValue = publisher.eraseToAnyPublisher()
        let store = TestStore(
            initialState: GameOverFeature.State(
                game: game
            ),
            reducer: {
                GameOverFeature()
            },
            withDependencies: {
                $0.sourceOfTruth = sourceOfTruth
            }
        )

        await store.send(.view(.onAppear))

        await store.receive(._didUpdateRightChoices(count: 0))
        publisher.send(
            [
                UserChoice.make(game: Date.distantPast, countryCode: "RU", pickedCountryCode: "RU"),
                UserChoice.make(game: game, countryCode: "IT", pickedCountryCode: "FR"),
                UserChoice.make(game: game, countryCode: "ES", pickedCountryCode: "ES"),
                UserChoice.make(game: game, countryCode: "FR", pickedCountryCode: "FR"),
            ]
        )
        await store.receive(._didUpdateRightChoices(count: 2)) {
            $0.score = 2
        }
        publisher.send(completion: .finished)
    }

    @Test("userDidTapRestartButton")
    func testUserDidTapRestartButton() async {
        let store = TestStore(
            initialState: GameOverFeature.State(
                game: Date.distantFuture
            ),
            reducer: {
                GameOverFeature()
            }
        )

        await store.send(.view(.userDidTapRestartButton))
        await store.receive(.delegate(.userDidTapRestartButton))
    }
}

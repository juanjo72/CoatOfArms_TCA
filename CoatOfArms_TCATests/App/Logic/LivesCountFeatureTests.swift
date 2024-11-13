//
//  LivesCountFeatureTests.swift
//  CoatOfArms_TCA
//
//  Created on 8/11/24.
//

@testable import CoatOfArms_TCA
import Combine
import ComposableArchitecture
import Foundation
import Testing

@Suite("LivesCountFeatureTests", .tags(.logicLayer)) @MainActor
struct LivesCountFeatureTests {
    @Test("onAppear")
    func testOnAppear() async {
        let game = Date.now
        let sourceOfTruth = StorageProtocolMock()
        let publisher = CurrentValueSubject<[UserChoice], Never>(
            [
                UserChoice.make(game: Date.distantPast, countryCode: "RU", pickedCountryCode: "ES"), // wrong, but not in this game
            ]
        )
        sourceOfTruth.getAllElementsObservableOfReturnValue = publisher.eraseToAnyPublisher()
        let store = TestStore(
            initialState: LivesCountFeature.State(id: game),
            reducer: {
                LivesCountFeature()
            },
            withDependencies: {
                $0.sourceOfTruth = sourceOfTruth
                $0.gameSettings = GameSettings.make(maxWrongAnwers: 5)
            }
        )

        await store.send(.view(.onAppear)) {
            $0.totalLives = 5
        }
        await store.receive(.update(numberOfLives: 5)) {
            $0.remainingLives = 5
        }
        publisher.send(
            [
                UserChoice.make(game: Date.distantPast, countryCode: "RU", pickedCountryCode: "ES"),
                UserChoice.make(game: game, countryCode: "IT", pickedCountryCode: "FR"), // wrong answer in current game
                UserChoice.make(game: game, countryCode: "ES", pickedCountryCode: "ES"),
                UserChoice.make(game: game, countryCode: "FR", pickedCountryCode: "FR"),
            ]
        )
        await store.receive(.update(numberOfLives: 4)) {
            $0.remainingLives = 4
        }
        publisher.send(completion: .finished)
    }
}

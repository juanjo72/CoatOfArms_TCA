//
//  RemainingLivesFeatureTests.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

@testable import CoatOfArms_TCA
import Combine
import ComposableArchitecture
import Testing

@Suite("RemainigLivesViewModel")
struct ReminingLivesViewModelTests {
    
    @Test("Total lives")
    @MainActor
    private func testThat_WhenCreated_ThenTotalLivesAreEqualToSettings() async throws {
        // Given
        let store = TestStore(
            initialState: RemainingLivesFeature.State(),
            reducer: {
                RemainingLivesFeature()
            },
            withDependencies: { dependencies in
                dependencies.gameSettings = .make(maxWrongAnwers: 3)
            }
        )
        store.exhaustivity = .off
        
        // When
        // Then
        await store.send(.viewWillAppear) { state in
            state.totalLives = 3
        }
    }
    
    @Test("Current lives")
    @MainActor
    private func testThat_WhenCreated_Then() async throws {
        // Given
        let repo = RemainingLivesRepositoryProtocolMock()
        repo.wrongAnswers = Just(
            [
                .make(countryCode: "ES", pickedCountryCode: "FR"),
                .make(countryCode: "IT", pickedCountryCode: "ES"),
            ]
        )
        .eraseToAnyPublisher()
        let store = TestStore(
            initialState: RemainingLivesFeature.State(),
            reducer: {
                RemainingLivesFeature()
            },
            withDependencies: { dependencies in
                dependencies.gameSettings = .make(maxWrongAnwers: 3)
                dependencies.remainingLivesRepository = repo
            }
        )
        
        // When
        await store.send(.viewWillAppear) { state in
            state.totalLives = 3
        }
        
        // Then
        await store.receive(\.update) { state in
            state.remainingLives = 1
        }
    }
}

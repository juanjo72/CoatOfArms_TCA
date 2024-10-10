//
//  AppFeatureTests.swift
//  CoatOfArms_TCA
//
//  Created on 9/10/24.
//

@testable import CoatOfArms_TCA
import ComposableArchitecture
import Foundation
import Testing

@Suite("AppFeature", .tags(.logicLayer)) @MainActor
struct AppFeatureTests {

    // MARK: viewWillAppear

    @Test("Automatically starts playing")
    func test_WhenViewWillAppear_ThenAppStatusIsPlaying() async throws {
        // Given
        let store = TestStore(
            initialState: AppFeature.State.idle,
            reducer: {
                AppFeature() // SUT
            },
            withDependencies: {
                $0.date = DateGenerator.constant(Date.distantFuture)
            }
        )

        // When
        await store.send(.viewWillAppear) {
            // Then
            $0 = .playing(GameFeature.State(id: Date.distantFuture))
        }
    }

    // MARK: Chilren's actions

    @Test("Detecting Game Over")
    func test_WhenGameOverInGame_ThenAppStatusIsGameOver() async throws {
        // Given
        let store = TestStore(
            initialState: AppFeature.State.playing(GameFeature.State(id: Date.distantFuture)),
            reducer: {
                AppFeature()
            }
        )

        // When
        await store.send(.playing(.gameOver(Date.distantFuture))) {
            // Then
            $0 = .gameOver(GameOverFeature.State(game: Date.distantFuture))
        }
    }

    @Test("Restart Button")
    func test_WhenInGameOverAndRestartButtonTapped_ThenAppStatusIsPlaying() async throws {
        // Given
        let store = TestStore(
            initialState: AppFeature.State.gameOver(.init(game: Date.distantFuture)),
            reducer: {
                AppFeature()
            },
            withDependencies: {
                $0.date = DateGenerator.constant(Date.distantPast)
            }
        )

        // When
        await store.send(.gameOver(.userDidTapRestartButton)) {
            // Then
            $0 = .playing(GameFeature.State(id: Date.distantPast))
        }
    }
}

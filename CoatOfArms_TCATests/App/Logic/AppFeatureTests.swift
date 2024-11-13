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
    @Test("onAppear")
    func testOnAppear() async throws {
        let store = TestStore(
            initialState: .idle,
            reducer: {
                AppFeature()
            },
            withDependencies: {
                $0.date = DateGenerator.constant(Date.distantFuture)
            }
        )

        await store.send(\.view.onAppear) {
            $0 = .playing(GameFeature.State(id: Date.distantFuture))
        }
    }

    @Test("Game Over")
    func testGameOver() async throws {
        let store = TestStore(
            initialState: .playing(GameFeature.State(id: Date.distantFuture)),
            reducer: {
                AppFeature()
            }
        )

        await store.send(.playing(.delegate(.gameOver(Date.distantFuture)))) {
            $0 = .gameOver(GameOverFeature.State(game: Date.distantFuture))
        }
    }

    @Test("New Game Button")
    func testRestart() async throws {
        let store = TestStore(
            initialState: .gameOver(.init(game: Date.distantFuture)),
            reducer: {
                AppFeature()
            },
            withDependencies: {
                $0.date = DateGenerator.constant(Date.distantPast)
            }
        )

        await store.send(.gameOver(.delegate(.userDidTapRestartButton))) {
            $0 = .playing(GameFeature.State(id: Date.distantPast))
        }
    }
}

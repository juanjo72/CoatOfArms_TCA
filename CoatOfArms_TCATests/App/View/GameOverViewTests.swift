//
//  GameOverViewTests.swift
//  CoatOfArms_TCA
//
//  Created on 15/11/24.
//

@testable import CoatOfArms_TCA
import ComposableArchitecture
import Foundation
import SnapshotTesting
import Testing

@Suite("Game Over", .tags(.viewLayer))
@MainActor
struct GameOverViewTests {
    @Test
    func testGameOver() {
        let view = GameOverView(
            store: Store(
                initialState: GameOverFeature.State(game: .now),
                reducer: { GameOverFeature() },
                withDependencies: .none
            ),
            style: .default
        ).environment(\.locale, Locale(identifier: "en"))

        withSnapshotTesting(diffTool: .ksdiff) {
            assertSnapshot(
                of: view,
                as: .image(
                    layout: .fixed(width: 300, height: 300)
                ),
                record: false
            )
        }
    }
}

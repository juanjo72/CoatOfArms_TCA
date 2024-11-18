//
//  QuestionViewTests.swift
//  CoatOfArms_TCA
//
//  Created on 15/11/24.
//

@testable import CoatOfArms_TCA
import Foundation
import ComposableArchitecture
import SnapshotTesting
import Testing
import SwiftUI

@Suite("QuestionView", .tags(.viewLayer))
@MainActor
struct QuestionViewTests {
    @Test
    func testQuestionView() {
        let questionId = Question.ID(
            gameStamp: .now,
            countryCode: "ES"
        )
        let network = NetworkProtocolMock()
        network.requestUrlThrowableError = NSError()
        let store = Store(
            initialState: QuestionFeature.State(
                id: questionId
            ),
            reducer: {
                QuestionFeature()
            },
            withDependencies: {
                $0.network = network
                $0.getCountryName = GetCountryName(locale: Locale(identifier: "en_US"))
            }
        )
        let view = QuestionView(
            store: store,
            style: .default
        )
        .padding()
        let image = Image("es", bundle: Bundle.main)
        let question = Question(
            id: questionId,
            coatOfArms: .image(image),
            otherChoices: ["IT", "FR", "DE"],
            rightChoicePosition: 2
        )
        store.send(._didObserve(question: question))

        withSnapshotTesting(diffTool: .ksdiff) {
            assertSnapshot(
                of: view,
                as: .image(
                    layout: .fixed(width: 402, height: 874)
                ),
                record: false
            )
        }
    }
}

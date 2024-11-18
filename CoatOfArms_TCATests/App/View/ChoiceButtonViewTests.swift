//
//  ChoiceButtonViewTests.swift
//  CoatOfArms_TCA
//
//  Created on 15/11/24.
//

@testable import CoatOfArms_TCA
import Combine
import ComposableArchitecture
import SnapshotTesting
import Testing

@Suite("Choice Button", .tags(.viewLayer))
@MainActor
struct ChoiceButtonTests {
    @Test
    func testUnselectedButton() {
        let view = ChoiceButtonView(
            store: Store(
                initialState: ChoiceButtonFeature.State(
                    id: "ES",
                    questionId: Question.ID(
                        gameStamp: .now,
                        countryCode: "ES"
                    )
                ),
                reducer: {
                    ChoiceButtonFeature()
                }
            ),
            style: .default
        )
        .padding()

        withSnapshotTesting(diffTool: .ksdiff) {
            withSnapshotTesting(diffTool: .ksdiff) {
                assertSnapshot(
                    of: view,
                    as: .image(
                        layout: .fixed(width: 300, height: 100)
                    ),
                    record: false
                )
            }
        }
    }

    @Test
    func testRightAnswerButton() {
        let questionId = Question.ID(
            gameStamp: .now,
            countryCode: "ES"
        )
        let view = ChoiceButtonView(
            store: Store(
                initialState: ChoiceButtonFeature.State(
                    id: "ES",
                    questionId: questionId
                ),
                reducer: {
                    ChoiceButtonFeature()
                },
                withDependencies: {
                    let sourceOfTruth = StorageProtocolMock()
                    sourceOfTruth.getSingleElementObservableOfIdReturnValue = Just<UserChoice?>(
                        UserChoice(id: questionId, pickedCountryCode: "ES")
                    ).eraseToAnyPublisher()
                    $0.sourceOfTruth = sourceOfTruth
                }
            ),
            style: .default
        )
        .padding()

        withSnapshotTesting(diffTool: .ksdiff) {
            withSnapshotTesting(diffTool: .ksdiff) {
                assertSnapshot(
                    of: view,
                    as: .image(
                        layout: .fixed(width: 300, height: 100)
                    ),
                    record: false
                )
            }
        }
    }

    @Test
    func testWrongAnswerButton() {
        let questionId = Question.ID(
            gameStamp: .now,
            countryCode: "FR"
        )
        let view = ChoiceButtonView(
            store: Store(
                initialState: ChoiceButtonFeature.State(
                    id: "ES",
                    questionId: questionId
                ),
                reducer: {
                    ChoiceButtonFeature()
                },
                withDependencies: {
                    let sourceOfTruth = StorageProtocolMock()
                    sourceOfTruth.getSingleElementObservableOfIdReturnValue = Just<UserChoice?>(
                        UserChoice(id: questionId, pickedCountryCode: "ES")
                    ).eraseToAnyPublisher()
                    $0.sourceOfTruth = sourceOfTruth
                }
            ),
            style: .default
        )
        .padding()

        withSnapshotTesting(diffTool: .ksdiff) {
            withSnapshotTesting(diffTool: .ksdiff) {
                assertSnapshot(
                    of: view,
                    as: .image(
                        layout: .fixed(width: 300, height: 100)
                    ),
                    record: false
                )
            }
        }
    }
}

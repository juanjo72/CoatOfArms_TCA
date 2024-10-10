//
//  ChoiceButtonFeatureTests.swift
//  CoatOfArms_TCA
//
//  Created on 9/10/24.
//

@testable import CoatOfArms_TCA
import Combine
import ComposableArchitecture
import SwiftUI
import Testing

@Suite("ChoiceButtonFeatureTests", .tags(.logicLayer)) @MainActor
struct ChoiceButtonFeatureTests {
    @Test("Button title")
    func test_WhenViewWillAppear_ThenLabelIsExpected() async throws {
        let questionId = Question.ID(
            gameStamp: .now,
            countryCode: "ES"
        )
        let getCountryName = GetCountryNameProtocolMock()
        getCountryName.callAsFunctionForReturnValue = "France"
        let store = TestStore(
            initialState: ChoiceButtonFeature.State(
                id: "ES",
                questionId: questionId
            ),
            reducer: {
                ChoiceButtonFeature()
            },
            withDependencies: {
                $0.getCountryName = getCountryName
            }
        )
        store.exhaustivity = .off

        await store.send(.viewWillAppear) {
            $0.label = "France"
        }
    }

    @Test("Button color", arguments: ["FR", "ES"])
    func example_2(code: String) async throws {
        let questionId = Question.ID(
            gameStamp: .now,
            countryCode: "ES"
        )
        let userChoice = UserChoice(id: questionId, pickedCountryCode: code)
        let getCountryName = GetCountryNameProtocolMock()
        getCountryName.callAsFunctionForReturnValue = "Title"
        let sourceOfTruth = StorageProtocolMock()
        sourceOfTruth.getSingleElementObservableOfIdReturnValue = Just<UserChoice?>(
            userChoice
        ).eraseToAnyPublisher()
        let store = TestStore(
            initialState: ChoiceButtonFeature.State(
                id: code,
                questionId: questionId
            ),
            reducer: {
                ChoiceButtonFeature()
            },
            withDependencies: { values in
                values.sourceOfTruth = sourceOfTruth
                values.getCountryName = getCountryName
            }
        )

        let task = await store.send(.viewWillAppear) {
            $0.label = "Title"
        }
        let expectedColor: [CountryCode: Color] = ["ES": .green, "FR": .red]
        await store.receive(.updateCurrentChoice(userChoice)) {
            $0.tint = expectedColor[code]!
        }
        await task.cancel()
    }

    @Test("User tapping")
    func test() async {
        let questionId = Question.ID(
            gameStamp: .now,
            countryCode: "ES"
        )
        let sourceOfTruth = StorageProtocolMock()
        sourceOfTruth.getSingleElementObservableOfIdReturnValue = Just<UserChoice?>(
            nil
        ).eraseToAnyPublisher()
        let store = TestStore(
            initialState: ChoiceButtonFeature.State(
                id: "FR",
                questionId: questionId
            ),
            reducer: {
                ChoiceButtonFeature()
            },
            withDependencies: {
                $0.sourceOfTruth = sourceOfTruth
            }
        )

        await store.send(.userDidTap)
        await store.receive(.answered(isCorrect: false))
        #expect(sourceOfTruth.addCallsCount == 1)
        #expect(sourceOfTruth.addReceivedElement as! UserChoice == UserChoice(id: questionId, pickedCountryCode: "FR"))
    }
}

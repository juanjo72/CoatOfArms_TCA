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
    @Test("onAppear", arguments: ["FR", "ES"])
    func testOnAppear(code: String) async throws {
        let questionId = Question.ID(
            gameStamp: .now,
            countryCode: "ES"
        )
        let userChoice = UserChoice(
            id: questionId,
            pickedCountryCode: code
        )
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
            withDependencies: {
                $0.getCountryName = getCountryName
                $0.sourceOfTruth = sourceOfTruth
            }
        )

        let task = await store.send(\.view.onAppear) {
            $0.label = "Title"
        }

        let expectedColor: [CountryCode: Color] = ["ES": .green, "FR": .red]
        await store.receive(._didObserveChoice(userChoice)) {
            $0.tint = expectedColor[code]!
        }
        await store.receive(.delegate(.didAnswer))
        await task.cancel()
    }

    @Test("userDidTap")
    func testUserDidTap() async {
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

        await store.send(.view(.userDidTap))
        #expect(sourceOfTruth.addCallsCount == 1)
        #expect(sourceOfTruth.addReceivedElement as! UserChoice == UserChoice(id: questionId, pickedCountryCode: "FR"))
    }
}

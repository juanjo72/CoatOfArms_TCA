//
//  QuestionFeatureTests.swift
//  CoatOfArms_TCA
//
//  Created on 13/11/24.
//

@testable import CoatOfArms_TCA
import Combine
import ComposableArchitecture
import Foundation
import Network
import Testing

@Suite("QuestionFeatureTests", .tags(.logicLayer)) @MainActor
struct QuestionFeatureTests {
    @Test("onAppear")
    func testOnAppear() async {
        let questionId = Question.ID(gameStamp: .now, countryCode: "ES")
        let gameSettings = GameSettings.make(numPossibleChoices: 1)
        let network = NetworkProtocolMock()
        network.requestUrlReturnValue = ServerResponse(
            country: ServerCountry(
                id: "ES",
                coatOfArmsURL: URL(string: "https://restcountries.com/v3.1/alpha/ES")!
            )
        )
        let randomCountryGenerator = RandomCountryCodeProviderProtocolMock()
        randomCountryGenerator.generateCodesNExcludingReturnValue = ["FR"]
        let sourceOfTruth = StorageProtocolMock()
        sourceOfTruth.getSingleElementObservableOfIdReturnValue = Just<Question?>(nil).eraseToAnyPublisher()
        let withRandomNumberGenerator = WithRandomNumberGenerator(FakeRandom(returnValue: 0))
        let store = TestStore(
            initialState: QuestionFeature.State(id: questionId),
            reducer: {
                QuestionFeature()
            },
            withDependencies: {
                $0.gameSettings = gameSettings
                $0.network = network
                $0.randomCountryGenerator = randomCountryGenerator
                $0.sourceOfTruth = sourceOfTruth
                $0.withRandomNumberGenerator = withRandomNumberGenerator
            }
        )

        await store.send(\.view.onAppear)
        await store.receive(._didObserve(question: nil))

        #expect(sourceOfTruth.addCallsCount == 1)
        let expectedQuestionToStore = Question(
            id: questionId,
            coatOfArmsURL: URL(string: "https://restcountries.com/v3.1/alpha/ES")!,
            otherChoices: ["FR"],
            rightChoicePosition: 0
        )
        #expect(sourceOfTruth.addReceivedElement as! Question == expectedQuestionToStore)
    }

    @Test("New question Load")
    func testObservedQuestion() async {
        let questionId = Question.ID(gameStamp: .now, countryCode: "ES")
        let sourceOfTruth = StorageProtocolMock()
        let publisher = CurrentValueSubject<Question?, Never>(nil)
        sourceOfTruth.getSingleElementObservableOfIdReturnValue = publisher.eraseToAnyPublisher()
        let withRandomNumberGenerator = WithRandomNumberGenerator(FakeRandom(returnValue: 0))
        let store = TestStore(
            initialState: QuestionFeature.State(id: questionId),
            reducer: {
                QuestionFeature()
            },
            withDependencies: {
                $0.sourceOfTruth = sourceOfTruth
                $0.withRandomNumberGenerator = withRandomNumberGenerator
            }
        )

        await store.send(\.view.onAppear)
        await store.receive(._didObserve(question: nil))

        let observedQuestion = Question(
            id: questionId,
            coatOfArmsURL: URL(string: "https://restcountries.com/v3.1/alpha/ES")!,
            otherChoices: ["FR"],
            rightChoicePosition: 0
        )
        publisher.send(observedQuestion)
        await store.receive(._didObserve(question: observedQuestion)) {
            $0.imageSource = .url(URL(string: "https://restcountries.com/v3.1/alpha/ES")!)
            $0.buttons = [
                ChoiceButtonFeature.State(id: "ES", questionId: questionId),
                ChoiceButtonFeature.State(id: "FR", questionId: questionId),
            ]
        }
        publisher.send(completion: .finished)
    }

    @Test("No Coat of Arms case")
    func testEmptyCoatOfArms() async {
        let questionId = Question.ID(gameStamp: .now, countryCode: "ES")
        let network = NetworkProtocolMock()
        network.requestUrlThrowableError = NSError()
        let sourceOfTruth = StorageProtocolMock()
        sourceOfTruth.getSingleElementObservableOfIdReturnValue = Just<Question?>(nil).eraseToAnyPublisher()
        let withRandomNumberGenerator = WithRandomNumberGenerator(FakeRandom(returnValue: 0))
        let store = TestStore(
            initialState: QuestionFeature.State(id: questionId),
            reducer: {
                QuestionFeature()
            },
            withDependencies: {
                $0.network = network
                $0.sourceOfTruth = sourceOfTruth
                $0.withRandomNumberGenerator = withRandomNumberGenerator
            }
        )

        await store.send(\.view.onAppear)
        await store.receive(._didObserve(question: nil))
        await store.receive(.delegate(.emptyCoatOfArmsError))
    }

    @Test("Choice button tapped")
    func testChoiceButtonTappedForwarding() async {
        let questionId = Question.ID(gameStamp: .now, countryCode: "ES")
        let sourceOfTruth = StorageProtocolMock()
        sourceOfTruth.getSingleElementObservableOfIdReturnValue = Just<Question?>(nil).eraseToAnyPublisher()
        let withRandomNumberGenerator = WithRandomNumberGenerator(FakeRandom(returnValue: 0))
        let store = TestStore(
            initialState: QuestionFeature.State(
                id: questionId,
                buttons: IdentifiedArrayOf(
                    uniqueElements: [
                        ChoiceButtonFeature.State(id: "ES", questionId: questionId),
                    ]
                )
            ),
            reducer: {
                QuestionFeature()
            },
            withDependencies: {
                $0.sourceOfTruth = sourceOfTruth
                $0.withRandomNumberGenerator = withRandomNumberGenerator
            }
        )

        await store.send(.buttons(.element(id: "ES", action: .delegate(.didAnswer))))
        await store.receive(.delegate(.didAnswer))
    }
}

struct FakeRandom: RandomNumberGenerator {
    let returnValue: UInt64

    func next() -> UInt64 {
        returnValue
    }
}

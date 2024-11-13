//
//  QuestionFeature.swift
//  CoatOfArms_TCA
//
//  Created on 3/10/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct QuestionFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: Question.ID
        var imageSource: ImageSource?
        var buttons: IdentifiedArrayOf<ChoiceButtonFeature.State> = []
    }
    
    enum Action: Equatable, ViewAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case buttons(IdentifiedActionOf<ChoiceButtonFeature>)
        case _didObserveQuestion(question: Question?)

        @CasePathable
        enum ViewAction {
            case onAppear
        }

        @CasePathable
        enum DelegateAction {
            case didAnswer
            case emptyCoatOfArmsError
        }
    }
    
    @Dependency(\.gameSettings) var gameSettings
    @Dependency(\.network) var network
    @Dependency(\.randomCountryGenerator) var randomCountryGenerator
    @Dependency(\.sourceOfTruth) var sourceOfTruth

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                let questionId = state.id
                return .publisher {
                    sourceOfTruth.getSingleElementObservable(
                        of: Question.self,
                        id: state.id
                    )
                    .map(Action._didObserveQuestion)
                }
                .merge(
                    with: .run(
                        operation: { _ in
                            let url = URL(string: "https://restcountries.com/v3.1/alpha/\(questionId.countryCode)")!
                            let response: ServerResponse = try await network.request(url: url)
                            let serverCountry = response.country
                            let otherChoices = self.randomCountryGenerator.generateCodes(
                                n: self.gameSettings.numPossibleChoices - 1,
                                excluding: [questionId.countryCode]
                            )
                            let rightChoicePosition = (0..<self.gameSettings.numPossibleChoices).randomElement()!
                            let question = Question(
                                id: questionId,
                                coatOfArmsURL: serverCountry.coatOfArmsURL,
                                otherChoices: otherChoices,
                                rightChoicePosition: rightChoicePosition
                            )
                            await self.sourceOfTruth.add(question)
                        },
                        catch: { error, send in
                            await send(.delegate(.emptyCoatOfArmsError))
                        }
                    )
                )

            case .buttons(.element(id: _, action: .delegate(.didAnswer))):
                return .run {
                    await $0(.delegate(.didAnswer))
                }

            case .buttons:
                return .none

            case .delegate:
                return .none

            case let ._didObserveQuestion(question):
                guard let question else {
                    return .none
                }
                var buttons: IdentifiedArrayOf<ChoiceButtonFeature.State> = []
                question.allChoices.forEach {
                    buttons.append(
                        ChoiceButtonFeature.State(id: $0, questionId: state.id)
                    )
                }
                state.imageSource = .url(question.coatOfArmsURL)
                state.buttons = buttons
                return .none
            }
        }
        .forEach(\.buttons, action: \.buttons) {
            ChoiceButtonFeature()
        }
    }
}

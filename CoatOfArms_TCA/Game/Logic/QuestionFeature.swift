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
    
    enum Action: Equatable {
        case viewWillAppear
        case update(question: Question?)
        case buttons(IdentifiedActionOf<ChoiceButtonFeature>)
    }
    
    @Dependency(\.sourceOfTruth) var sourceOfTruth
    @Dependency(\.gameSettings) var gameSettings
    @Dependency(\.network) var network
    @Dependency(\.randomCountryGenerator) var randomCountryGenerator
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewWillAppear:
                let questionId = state.id
                return .publisher {
                    sourceOfTruth.getSingleElementObservable(
                        of: Question.self,
                        id: state.id
                    )
                    .map(Action.update)
                }
                .merge(
                    with: .run { _ in
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
                    }
                )

            case .update(let question):
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
                
            case .buttons(let action):
                return .none
            }
        }
        .forEach(\.buttons, action: \.buttons) {
            ChoiceButtonFeature()
        }
    }
}

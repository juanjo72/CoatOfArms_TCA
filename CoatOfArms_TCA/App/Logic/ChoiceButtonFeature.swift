//
//  ChoiceButtonFeature.swift
//  CoatOfArms_TCA
//
//  Created on 30/9/24.
//

import Combine
import ComposableArchitecture
import ReactiveStorage
import SwiftUI

@Reducer
struct ChoiceButtonFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: CountryCode
        let questionId: Question.ID
        var label: String = ""
        var tint: Color = .clear
    }

    enum Action: Equatable, ViewAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case _didObserveChoice(UserChoice?)

        @CasePathable
        enum ViewAction {
            case onAppear
            case userDidTap
        }

        @CasePathable
        enum DelegateAction: Equatable {
            case didAnswer
        }
    }

    @Dependency(\.getCountryName) var getCountryName
    @Dependency(\.playSound) var playSound
    @Dependency(\.sourceOfTruth) var sourceOfTruth

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                state.label = getCountryName(for: state.id)
                let buttonId = state.id
                return .publisher {
                    sourceOfTruth.getSingleElementObservable(
                        of: UserChoice.self,
                        id: state.questionId
                    )
                    .filter { choice in
                        guard let choice else { return true }
                        return choice.pickedCountryCode == buttonId
                    }
                    .map(Action._didObserveChoice)
                }

            case .view(.userDidTap):
                let buttonId = state.id
                let questionId = state.questionId
                return .run { send in
                    let answer = UserChoice(
                        id: questionId,
                        pickedCountryCode: buttonId
                    )
                    await sourceOfTruth.add(answer)
                }

            case ._didObserveChoice(let choice):
                guard let choice else {
                    state.tint = .accentColor
                    return .none
                }
                state.tint = choice.isCorrect ? .green : .red
                return .run { send in
                    if choice.isCorrect {
                        await playSound(sound: .rightAnswer)
                    } else {
                        await playSound(sound: .wrongAnswer)
                    }

                    await send(.delegate(.didAnswer))
                }

            case .delegate:
                return .none
            }

        }
    }
}

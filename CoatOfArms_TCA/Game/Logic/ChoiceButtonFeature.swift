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
        var tint: Color = .accentColor
    }
    
    enum Action: Equatable {
        case viewWillAppear
        case userDidTap
        case updateCurrentChoice(UserChoice?)
        case done
    }

    @Dependency(\.gameSettings) var gameSetting
    @Dependency(\.getCountryName) var getCountryName
    @Dependency(\.playSound) var playSound
    @Dependency(\.sourceOfTruth) var sourceOfTruth
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewWillAppear:
                let buttonId = state.id
                state.label = getCountryName(for: state.id)
                return .publisher {
                    sourceOfTruth.getSingleElementObservable(
                        of: UserChoice.self,
                        id: state.questionId
                    )
                    .filter { choice in
                        guard let choice else { return true }
                        return choice.pickedCountryCode == buttonId
                    }
                    .map(Action.updateCurrentChoice)
                }

            case .userDidTap:
                let buttonId = state.id
                let questionId = state.questionId
                return .run { send in
                    let answer = UserChoice(
                        id: questionId,
                        pickedCountryCode: buttonId
                    )
                    await sourceOfTruth.add(answer)
                    
                    if answer.isCorrect {
                        await playSound(sound: .rightAnswer)
                    } else {
                        await playSound(sound: .wrongAnswer)
                    }
                    
                    try? await Task.sleep(for: gameSetting.resultTime)
                    await send(.done)
                }
                
            case .updateCurrentChoice(let choice):
                guard let choice else {
                    state.tint = .accentColor
                    return .none
                }
                state.tint = choice.isCorrect ? .green : .red
                return .none
                
            case .done:
                return .none
            }
        }
    }
}

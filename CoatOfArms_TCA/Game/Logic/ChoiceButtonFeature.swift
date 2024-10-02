//
//  ChoiceButtonFeature.swift
//  CoatOfArms_TCA
//
//  Created on 30/9/24.
//

import ComposableArchitecture
import ReactiveStorage
import SwiftUI

@Reducer
struct ChoiceButtonFeature {
    @ObservableState
    struct State: Equatable {
        var label: String = ""
        var tint: Color = .clear
    }
    
    enum Action {
        case viewWillAppear
        case userDidTap
        case updateCurrentChoice(UserChoice?)
    }
    
    @Dependency(\.buttonCountry) var buttonCountry
    @Dependency(\.gameSettings) var gameSetting
    @Dependency(\.getCountryName) var getCountryName
    @Dependency(\.playSound) var playSound
    @Dependency(\.choiceButtonRepository) var repository
    @Dependency(\.gameRouter) var gameRouter
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewWillAppear:
                state.label = getCountryName(for: buttonCountry)
                return .publisher {
                    repository.userChoiceObservable
                        .map(Action.updateCurrentChoice)
                }

            case .userDidTap:
                return .run { send in
                    let choice = await repository.markAsChoice()
                    
                    if choice.isCorrect {
                        await playSound(sound: .rightAnswer)
                    } else {
                        await playSound(sound: .wrongAnswer)
                    }
                    
                    try? await Task.sleep(for: gameSetting.resultTime)
                    await gameRouter.gotNextQuestion()
                }
                
            case .updateCurrentChoice(let choice):
                guard let choice else {
                    state.tint = .accentColor
                    return .none
                }
                state.tint = choice.isCorrect ? .green : .red
                return .none
            }
        }
    }
}

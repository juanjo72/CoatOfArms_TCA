//
//  Dependencies.swift
//  CoatOfArms_TCA
//
//  Created on 1/10/24.
//

import ComposableArchitecture

private enum GameSettingsKey: DependencyKey {
    static var liveValue: GameSettings {
        .default
    }
    
    static var testValue: GameSettings {
        GameSettings(
            numPossibleChoices: 4,
            resultTime: .zero,
            maxWrongAnswers: 3
        )
    }
}

extension DependencyValues {
    var gameSettings: GameSettings {
        get { self[GameSettingsKey.self] }
        set { self[GameSettingsKey.self] = newValue }
    }
}

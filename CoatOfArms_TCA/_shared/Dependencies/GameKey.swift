//
//  GameKey.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import ComposableArchitecture
import Foundation

private enum GameKey: DependencyKey {
    static var liveValue: GameStamp {
        Date(timeIntervalSince1970: 0)
    }
}

extension DependencyValues {
    var game: GameStamp {
        get { self[GameKey.self] }
        set { self[GameKey.self] = newValue }
    }
}

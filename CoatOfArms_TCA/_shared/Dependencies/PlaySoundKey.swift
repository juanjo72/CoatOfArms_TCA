//
//  PlaySoundKey.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import ComposableArchitecture

private enum PlaySoundKey: DependencyKey {
    static var liveValue: any PlaySoundProtocol {
        PlaySound()
    }
    
    static var testValue: any PlaySoundProtocol {
        let mock = PlaySoundProtocolMock()
        return mock
    }
}

extension DependencyValues {
    var playSound: PlaySoundProtocol {
        get { self[PlaySoundKey.self] }
        set { self[PlaySoundKey.self] = newValue }
    }
}

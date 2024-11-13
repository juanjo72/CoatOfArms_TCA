//
//  PlaySoundProtocolMock.swift
//  CoatOfArms_TCA
//
//  Created on 8/10/24.
//

final class PlaySoundProtocolMock: PlaySoundProtocol, @unchecked Sendable {

   // MARK: - callAsFunction

    var callAsFunctionSoundCallsCount = 0
    var callAsFunctionSoundCalled: Bool {
        callAsFunctionSoundCallsCount > 0
    }
    var callAsFunctionSoundReceivedSound: SoundEffect?
    var callAsFunctionSoundReceivedInvocations: [SoundEffect] = []
    var callAsFunctionSoundClosure: ((SoundEffect) -> Void)?

    func callAsFunction(sound: SoundEffect) {
        callAsFunctionSoundCallsCount += 1
        callAsFunctionSoundReceivedSound = sound
        callAsFunctionSoundReceivedInvocations.append(sound)
        callAsFunctionSoundClosure?(sound)
    }
}

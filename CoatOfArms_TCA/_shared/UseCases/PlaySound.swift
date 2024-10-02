//
//  PlaySound.swift
//  CoatOfArms
//
//  Created on 20/9/24.
//

import AudioToolbox

enum SoundEffect: SystemSoundID {
    case rightAnswer = 1057
    case wrongAnswer = 1006
}

protocol PlaySoundProtocol {
    func callAsFunction(sound: SoundEffect) async
}

final class PlaySound: PlaySoundProtocol {
    func callAsFunction(sound: SoundEffect) async {
        await withCheckedContinuation { continuation in
            AudioServicesPlaySystemSoundWithCompletion(sound.rawValue) {
                continuation.resume()
            }
        }
    }
}

// MARK: - PlaySoundProtocolMock -

final class PlaySoundProtocolMock: PlaySoundProtocol {
    
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

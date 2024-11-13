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

protocol PlaySoundProtocol: Sendable {
    func callAsFunction(sound: SoundEffect) async
}

final class PlaySound: PlaySoundProtocol, @unchecked Sendable {
    func callAsFunction(sound: SoundEffect) async {
        await withCheckedContinuation { continuation in
            AudioServicesPlaySystemSoundWithCompletion(sound.rawValue) {
                continuation.resume()
            }
        }
    }
}

//
//  FakeRandom.swift
//  CoatOfArms_TCA
//
//  Created on 16/11/24.
//

struct FakeRandom: RandomNumberGenerator {
    let returnValue: UInt64

    func next() -> UInt64 {
        returnValue
    }
}

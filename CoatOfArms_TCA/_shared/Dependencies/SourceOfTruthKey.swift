//
//  SourceOfTruthKey.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import ComposableArchitecture
import ReactiveStorage

private enum SourceOfTruthKey: DependencyKey {
    static var liveValue: any StorageProtocol {
        ReactiveStorage.ReactiveInMemoryStorage()
    }
    
    static var testValue: any StorageProtocol {
        ReactiveStorage.ReactiveInMemoryStorage()
    }
}

extension DependencyValues {
    var sourceOfTruth: any StorageProtocol {
        get { self[SourceOfTruthKey.self] }
        set { self[SourceOfTruthKey.self] = newValue }
    }
}

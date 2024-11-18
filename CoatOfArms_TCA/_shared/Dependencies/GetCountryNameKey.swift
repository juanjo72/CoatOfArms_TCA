//
//  GetCountryNameKey.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import ComposableArchitecture
import Foundation

private enum GetCountryNameKey: DependencyKey {
    static var liveValue: GetCountryNameProtocol {
        GetCountryName()
    }
    
    static var testValue: any GetCountryNameProtocol {
        let mock = GetCountryNameProtocolMock()
        mock.callAsFunctionForReturnValue = "Spain"
        return mock
    }

    static var previewValue: any GetCountryNameProtocol {
        GetCountryName(locale: Locale(identifier: "en_US"))
    }
}

extension DependencyValues {
    var getCountryName: GetCountryNameProtocol {
        get { self[GetCountryNameKey.self] }
        set { self[GetCountryNameKey.self] = newValue }
    }
}

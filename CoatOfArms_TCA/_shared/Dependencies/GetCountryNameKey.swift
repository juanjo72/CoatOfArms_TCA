//
//  GetCountryNameKey.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import ComposableArchitecture

private enum GetCountryNameKey: DependencyKey {
    static var liveValue: GetCountryNameProtocol {
        GetCountryName()
    }
    
    static var testValue: any GetCountryNameProtocol {
        let mock = GetCountryNameProtocolMock()
        mock.callAsFunctionForReturnValue = "Spain"
        return mock
    }
}

extension DependencyValues {
    var getCountryName: GetCountryNameProtocol {
        get { self[GetCountryNameKey.self] }
        set { self[GetCountryNameKey.self] = newValue }
    }
}

final class GetCountryNameProtocolMock: GetCountryNameProtocol {
    
   // MARK: - callAsFunction

    var callAsFunctionForCallsCount = 0
    var callAsFunctionForCalled: Bool {
        callAsFunctionForCallsCount > 0
    }
    var callAsFunctionForReceivedCountry: CountryCode?
    var callAsFunctionForReceivedInvocations: [CountryCode] = []
    var callAsFunctionForReturnValue: String!
    var callAsFunctionForClosure: ((CountryCode) -> String)?

    func callAsFunction(for country: CountryCode) -> String {
        callAsFunctionForCallsCount += 1
        callAsFunctionForReceivedCountry = country
        callAsFunctionForReceivedInvocations.append(country)
        return callAsFunctionForClosure.map({ $0(country) }) ?? callAsFunctionForReturnValue
    }
}

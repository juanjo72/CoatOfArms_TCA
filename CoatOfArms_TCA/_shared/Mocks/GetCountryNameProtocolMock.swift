//
//  GetCountryNameProtocolMock.swift
//  CoatOfArms_TCA
//
//  Created on 8/10/24.
//

final class GetCountryNameProtocolMock: GetCountryNameProtocol, @unchecked Sendable {

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

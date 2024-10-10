//
//  NetworkKey.swift
//  CoatOfArms_TCA
//
//  Created on 3/10/24.
//

import ComposableArchitecture
import Foundation
import Network

private enum NetworkKey: DependencyKey {
    static var liveValue: any NetworkProtocol {
        NetworkAdapter(sender: Network.RequestSender.shared())
    }
    
    static var testValue: any NetworkProtocol {
        let mock = NetworkProtocolMock()
        mock.requestUrlReturnValue = ServerResponse(
            country: ServerCountry(
                id: "ES",
                coatOfArmsURL: URL(string: "https://restcountries.com/v3.1/alpha/ES")!
            )
        )
        return mock
    }
}

extension DependencyValues {
    var network: any NetworkProtocol {
        get { self[NetworkKey.self] }
        set { self[NetworkKey.self] = newValue }
    }
}

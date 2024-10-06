//
//  NetworkKey.swift
//  CoatOfArms_TCA
//
//  Created on 3/10/24.
//

import ComposableArchitecture
import Network

private enum NetworkKey: DependencyKey {
    static var liveValue: any NetworkProtocol {
        NetworkAdapter(sender: Network.RequestSender.shared())
    }
    
    static var testValue: any NetworkProtocol {
        NetworkProtocolMock()
    }
}

extension DependencyValues {
    var network: any NetworkProtocol {
        get { self[NetworkKey.self] }
        set { self[NetworkKey.self] = newValue }
    }
}

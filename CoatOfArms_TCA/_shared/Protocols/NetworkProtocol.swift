//
//  NetworkProtocol.swift
//  CoatOfArms
//
//  Created on 9/9/24.
//

import Foundation
import Network

protocol NetworkProtocol {
    func request<T: Decodable>(url: URL) async throws -> T
}

/// Adapter converting third party's RequestSenderProtocol to local NetworkProtocol
struct NetworkAdapter: NetworkProtocol {
    private let sender: any Network.RequestSenderProtocol
    
    init(
        sender: any Network.RequestSenderProtocol
    ) {
        self.sender = sender
    }
    
    func request<T: Decodable>(url: URL) async throws -> T {
        let resource: RemoteResource<T> = Network.RemoteResource(
            url: url,
            requestTimeOut: 5
        )
        return try await self.sender.request(resource: resource)
    }
}

// MARK: - NetworkProtocolMock -

final class NetworkProtocolMock: NetworkProtocol {
    
   // MARK: - request<T: Decodable>

    var requestUrlThrowableError: Error?
    var requestUrlCallsCount = 0
    var requestUrlCalled: Bool {
        requestUrlCallsCount > 0
    }
    var requestUrlReceivedUrl: URL?
    var requestUrlReceivedInvocations: [URL] = []
    var requestUrlReturnValue: Any!
    var requestUrlClosure: ((URL) throws -> Any)?

    func request<T: Decodable>(url: URL) throws -> T {
        if let error = requestUrlThrowableError {
            throw error
        }
        requestUrlCallsCount += 1
        requestUrlReceivedUrl = url
        requestUrlReceivedInvocations.append(url)
        return try requestUrlClosure.map({ try $0(url) as! T }) ?? requestUrlReturnValue as! T
    }
}

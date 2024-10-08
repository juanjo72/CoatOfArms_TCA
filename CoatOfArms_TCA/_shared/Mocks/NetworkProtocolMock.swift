//
//  NetworkProtocolMock.swift
//  CoatOfArms_TCA
//
//  Created on 8/10/24.
//

import Foundation

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

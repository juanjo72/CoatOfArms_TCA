//
//  CoatOfArms_TCATests_2.swift
//  CoatOfArms_TCATests_2
//
//  Created on 11/10/24.
//

@testable import CoatOfArms_TCA
import ComposableArchitecture
import Testing

@MainActor
struct CoatOfArms_TCATests_2 {

    @Test func example() async throws {
        let store = TestStore(initialState: AppFeature.State.idle, reducer: { AppFeature() })
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}

//
//  CoatOfArms_TCAApp.swift
//  CoatOfArms_TCA
//
//  Created on 30/9/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct CoatOfArms_TCAApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppFeature.State.idle,
                    reducer: {
                        AppFeature()
                    }
                )
            )
        }
    }
}

//
//  AppView.swift
//  CoatOfArms_TCA
//
//  Created on 7/10/24.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: AppFeature.self)
struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        ZStack {
            switch store.state {
            case .idle:
                Spacer()

            case .playing:
                if let childStore = store.scope(state: \.playing, action: \.playing) {
                    GameView(store: childStore, style: .default)
                }

            case .gameOver:
                if let childStore = store.scope(state: \.gameOver, action: \.gameOver) {
                    GameOverView(store: childStore)
                }
            }
        }
        .onAppear {
            send(.onAppear)
        }
    }
}

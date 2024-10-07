//
//  AppFeature.swift
//  CoatOfArms_TCA
//
//  Created on 7/10/24.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
    @ObservableState
    enum State: Equatable {
        case idle
        case playing(GameFeature.State)
        case gameOver
    }
    
    enum Action: Equatable {
        case viewWillAppear
        case playing(GameFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewWillAppear:
                state = .playing(GameFeature.State(id: .now))
                return .none
            case .playing(GameFeature.Action.gameOver):
                state = .gameOver
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.playing, action: \.playing ) {
            GameFeature()
        }
    }
}

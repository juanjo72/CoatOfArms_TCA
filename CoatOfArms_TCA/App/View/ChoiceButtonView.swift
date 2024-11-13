//
//  ChoiceButtonView.swift
//  CoatOfArms_TCA
//
//  Created on 30/9/24.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: ChoiceButtonFeature.self)
struct ChoiceButtonView: View {
    let store: StoreOf<ChoiceButtonFeature>
    
    var body: some View {
        Button(
            action: {
                send(.userDidTap)
            },
            label: {
                Text(store.label)
                    .font(.title2)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(store.tint)
        .clipShape(Capsule())
        .onAppear() {
            send(.onAppear)
        }
    }
}

#Preview {
    ChoiceButtonView(
        store: Store(
            initialState: ChoiceButtonFeature.State(
                id: "ES",
                questionId: Question.ID(
                    gameStamp: .now,
                    countryCode: "ES"
                )
            ),
            reducer: {
                ChoiceButtonFeature()
            }
        )
    )
    .padding()
}
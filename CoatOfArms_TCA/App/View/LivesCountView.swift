//
//  LivesCountView.swift
//  CoatOfArms_TCA
//
//  Created on 2/10/24.
//

import Combine
import ComposableArchitecture
import SwiftUI

@ViewAction(for: LivesCountFeature.self)
struct LivesCountView: View {
    let store: StoreOf<LivesCountFeature>
    let style: Style

    var body: some View {
        HStack {
            ForEach(0..<self.store.totalLives, id:\.self) {
                Image(
                    systemName: $0 < self.store.remainingLives
                    ? "heart.fill"
                    : "heart.slash.fill"
                )
                .imageScale(.large)
                .foregroundColor(style.tint)
                .animation(.easeOut, value: self.store.remainingLives)
            }
        }
        .frame(minHeight: style.height)
        .accessibilityElement(children: .ignore)
        .accessibilityValue("You have \(self.store.remainingLives) lives left")
        .onAppear() {
            send(.onAppear)
        }
    }
}

extension LivesCountView {
    struct Style {
        let height: CGFloat
        let tint: Color
    }
}

#Preview("Remaining lives") {
    LivesCountView(
        store: Store(
            initialState: LivesCountFeature.State(
                id: .now
            ),
            reducer: {
                LivesCountFeature()
            },
            withDependencies: {
                let truth = StorageProtocolMock()
                truth.getAllElementsObservableOfReturnValue = Just<[UserChoice]>([]).eraseToAnyPublisher()
                $0.sourceOfTruth = truth
            }
        ),
        style: .default
    )
}

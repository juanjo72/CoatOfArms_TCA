//
//  QuestionView.swift
//  CoatOfArms
//
//  Created on 20/8/24.
//

import ComposableArchitecture
import Kingfisher
import SwiftUI

enum ImageSource: Equatable {
    case url(URL)
    case image(Image)
}

@ViewAction(for: QuestionFeature.self)
struct QuestionView: View {
    let store: StoreOf<QuestionFeature>
    let style: Style

    var body: some View {
        VStack(
            spacing: style.vSpacing
        ) {
            Spacer()
            
            if let imageSource = store.imageSource {
                Group {
                    switch imageSource {
                    case .image(let image):
                        image
                            .resizable()
                    case .url(let url):
                        KFImage(url)
                            .resizable()
                    }
                }
                .allowsHitTesting(false)
                .aspectRatio(contentMode: .fit)
                .padding()
            }
            
            VStack {
                ForEach(
                    store.scope(state: \.buttons, action: \.buttons)
                ) { childStore in
                    ChoiceButtonView(store: childStore, style: style.button)
                }
            }
            .layoutPriority(1)
        }
        .onAppear() {
            send(.onAppear)
        }
    }
}

extension QuestionView {
    struct Style {
        let button: ChoiceButtonView.Style
        let vSpacing: CGFloat
    }
}

#Preview {
    QuestionView(
        store: Store(
            initialState: QuestionFeature.State(
                id: Question.ID(
                    gameStamp: .now,
                    countryCode: "ES"
                )
            ),
            reducer: {
                QuestionFeature()
            }
        ),
        style: .default
    )
    .padding()
}

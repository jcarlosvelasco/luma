//
//  StylesTabView.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI

struct StylesTabView: View {
    @ObservedObject var viewModel: HomeViewViewModel

    var body: some View {
        if viewModel.orientation.isPortrait {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    styleViews()
                    Spacer()
                }
                .padding(.horizontal)
            }
        } else {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    styleViews()
                }
            }
        }
    }

    @ViewBuilder
    private func styleViews() -> some View {
        StyleView(
            viewModel: viewModel,
            text: "Mosaic",
            action: {
                await viewModel.setStyle(.mosaic)
            },
            styleTab: .mosaic
        )
        StyleView(
            viewModel: viewModel,
            text: "Candy",
            action: {
                await viewModel.setStyle(.candy)
            },
            styleTab: .candy
        )
        StyleView(
            viewModel: viewModel,
            text: "Pointilism",
            action: {
                await viewModel.setStyle(.pontillism)
            },
            styleTab: .pontilism
        )
        StyleView(
            viewModel: viewModel,
            text: "Udnie",
            action: {
                await viewModel.setStyle(.udnie)
            },
            styleTab: .udnie
        )
        StyleView(
            viewModel: viewModel,
            text: "Rain Princess",
            action: {
                await viewModel.setStyle(.rainPrincess)
            },
            styleTab: .rainPrincess
        )
        StyleView(
            viewModel: viewModel,
            text: "Cartoon",
            action: {
                await viewModel.setStyle(.cartoon)
            },
            styleTab: .cartoon
        )
    }
}

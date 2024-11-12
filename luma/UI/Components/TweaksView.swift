//
//  TweaksView.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI

struct TweaksView: View {
    @ObservedObject var viewModel: HomeViewViewModel
            
    var body: some View {
        VStack(spacing: 10) {
            tweakSlider(label: "Contrast", value: $viewModel.contrast, range: 0...2)
            tweakSlider(label: "Saturation", value: $viewModel.saturation, range: 0...2)
            tweakSlider(label: "Brighness", value: $viewModel.brightness, range: -0.5...0.5)
        }
        .padding(.horizontal)
        .onAppear {
            Task {
                await viewModel.applyTweaks()
            }
        }
        .frame(maxWidth: viewModel.orientation.isLandscape ? 300 : .infinity)
    }
        
    @ViewBuilder
    private func tweakSlider(label: String, value: Binding<Double>, range: ClosedRange<Double>) -> some View {
        VStack(spacing: 2) {
            HStack {
                Text(label)
                Spacer()
            }
            
            Slider(value: value, in: range, onEditingChanged: { _ in
                Task {
                    await viewModel.applyTweaks()
                }
            })
        }
    }
}

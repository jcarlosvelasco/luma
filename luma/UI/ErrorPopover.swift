//
//  ErrorPopover.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI
import Combine

func iosModel() -> ModelInfo {
    guard deviceSupportsQuantization else { return ModelInfo.ofaSmall }
    return ModelInfo.v21Palettized
}

struct ErrorPopover: View {
    var errorMessage: String

    var body: some View {
        Text(errorMessage)
            .font(.headline)
            .padding()
            .foregroundColor(.red)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

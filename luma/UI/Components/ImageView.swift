//
//  ImageView.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var viewModel: HomeViewViewModel

    var body: some View {
        if viewModel.loading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
        }
        else {
            if let preview = viewModel.imagePreview {
                    Image(uiImage: preview)
                        .resizable()
                        .scaledToFit()
                
            }
            else if let image = viewModel.displayedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

//
//  StyleView.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI

struct StyleView: View {
    @ObservedObject var viewModel: HomeViewViewModel
    let text: String
    let action: () async -> Void
    let styleTab: StyleTabs
    
    var body: some View {
        Button(action: {
            viewModel.loading = true
            viewModel.selectedStyleTab = styleTab
           
            Task {
                await action()
                viewModel.loading = false
            }
        }) {
            Text(text)
        }
        .disabled(viewModel.displayedImage == nil || viewModel.loading == true)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .foregroundColor(viewModel.selectedStyleTab == self.styleTab ? Color.white : (viewModel.displayedImage == nil || viewModel.loading ? Color.gray.opacity(0.5) : Color.blue))
        .background(viewModel.selectedStyleTab == styleTab ? .blue : .clear)
        .foregroundColor(viewModel.selectedStyleTab == styleTab ? .white : .blue)
        .clipShape(Capsule())
    }
}

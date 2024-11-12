//
//  BottomTabButton.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI

struct BottomTabButton: View {
    let text: String
    let action: () -> Void
    let tab: NavigationTabs
    @ObservedObject var viewModel: HomeViewViewModel
    let disabledCondition: Bool

    var body: some View {
        Button(text) {
            withAnimation {
                self.action()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .foregroundColor(viewModel.selectedTab == self.tab ? Color.white : (disabledCondition ? Color.gray.opacity(0.5) : Color.blue))
        .disabled(disabledCondition)
        .background(viewModel.selectedTab == self.tab ? .blue : .clear)
        .foregroundColor(viewModel.selectedTab == self.tab ? .white : .blue)
        .clipShape(Capsule())
    }
}

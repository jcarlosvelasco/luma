//
//  FilterView.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI

struct FilterView: View {
    let filter: FiltersTabView.Filter
    @ObservedObject var viewModel: HomeViewViewModel
    let tab: FilterTabs
    
    var body: some View {
        VStack {
            Image(filter.name)
                .resizable()
                .frame(width: 70, height: 70)
                .cornerRadius(10)
            
            Text(filter.name)
        }
        .onTapGesture {
            Task {
                await viewModel.applyFilter(filter: filter.type)
            }
            
            viewModel.selectedFilterTab = self.tab
        }
        .padding()
        .background(viewModel.selectedFilterTab == self.tab ? .gray.opacity(0.5) : .clear)
        .cornerRadius(20)
    }
}

//
//  FiltersTabView.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI

struct FiltersTabView: View {
    
    struct Filter: Identifiable {
        let id = UUID()
        let name: String
        let type: FilterType
        let tab: FilterTabs
    }
    
    @ObservedObject var viewModel: HomeViewViewModel
    
    let filters = [
        Filter(name: "Chrome", type: .Chrome, tab: FilterTabs.chrome),
        Filter(name: "Fade", type: .Fade, tab: FilterTabs.fade),
        Filter(name: "Instant", type: .Instant, tab: FilterTabs.instant),
        Filter(name: "Mono", type: .Mono, tab: FilterTabs.mono),
        Filter(name: "Noir", type: .Noir, tab: FilterTabs.noir),
        Filter(name: "Process", type: .Process, tab: FilterTabs.process),
        Filter(name: "Tonal", type: .Tonal, tab: FilterTabs.tonal),
        Filter(name: "Transfer", type: .Transfer, tab: FilterTabs.transfer)
    ]
    
    var body: some View {
        if viewModel.orientation.isPortrait {
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(filters) { filter in
                        FilterView(filter: filter, viewModel: viewModel, tab: filter.tab)
                    }
                }
            }
            .padding(.horizontal)
        } else {
            ScrollView(.vertical) {
                VStack(spacing: 5) {
                    ForEach(filters) { filter in
                        FilterView(filter: filter, viewModel: viewModel, tab: filter.tab)
                    }
                }
            }
        }
    }
}

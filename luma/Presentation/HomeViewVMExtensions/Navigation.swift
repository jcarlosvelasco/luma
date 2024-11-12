//
//  Navigation.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import Foundation

extension HomeViewViewModel {
    enum CurrentView {
        case homeview
        case loading
        case error(String)
    }
    
    func setNavigationTab(tab: NavigationTabs) {
        self.selectedTab = tab
    }
    
    func resetTabs() {
        self.selectedTab = .none
    }
}

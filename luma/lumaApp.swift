//
//  lumaApp.swift
//  luma
//
//  Created by Juan Carlos Velasco on 12/11/24.
//

import SwiftUI

@main
struct lumaApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(
                homeViewVM: HomeViewViewModel(),
                settingsVM: SettingsViewViewModel()
            )
        }
    }
}

let runningOnMac = ProcessInfo.processInfo.isMacCatalystApp
let deviceHas6GBOrMore = ProcessInfo.processInfo.physicalMemory > 5910000000   // Reported by iOS 17 beta (21A5319a) on iPhone 13 Pro: 5917753344
let deviceHas8GBOrMore = ProcessInfo.processInfo.physicalMemory > 7900000000   // Reported by iOS 17.0.2 on iPhone 15 Pro Max: 8021032960

let deviceSupportsQuantization = {
    if #available(iOS 17, *) {
        true
    } else {
        false
    }
}()

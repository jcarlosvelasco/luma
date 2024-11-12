//
//  SettingsView.swift
//  ImageApp2
//
//  Created by Juan Carlos Velasco on 13/8/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var vm: SettingsViewViewModel
    
    init(vm: SettingsViewViewModel) {
        self.vm = vm
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Image generation quality") {
                    Picker("Tip percentage", selection: $vm.qualityMode) {
                        ForEach(vm.qualityModes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: vm.qualityMode) {
                        vm.setQualityMode()
                    }
                    .disabled(!vm.modelDownloaded)
                }
                
                Section("Image models") {
                    Button("Delete image generation model", role: .destructive) {
                        vm.showingAlert = true
                    }
                    .disabled(!vm.modelDownloaded)
                    .alert("If you delete the model, you will have to download it again in order to use some features. Are you sure?", isPresented: $vm.showingAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            vm.onDeleteImage2ImageModel()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            vm.checkStatus()
        }
    }
}

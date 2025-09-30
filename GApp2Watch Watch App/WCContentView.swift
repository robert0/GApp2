//
//  ContentView.swift
//  GApp2 Watch App
//
//  Created by Robert Talianu
//

import SwiftUI

struct WCContentView: View {
    @ObservedObject var viewModel: WCContentViewModel = WCContentViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to GWatch 1.8.5!")
            
            if(viewModel.infoMessage != nil) {
                Text("New msg: \(viewModel.infoMessage!)")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    
    public func showMessage(_ message: String) {
        viewModel.infoMessage = message
    }
    
}

//
// Helper class for DataView that handles the updates
//
// Created by Robert Talianu
//
final class WCContentViewModel: ObservableObject {
    @Published var infoMessage: String?
}


#Preview {
    WCContentView()
}

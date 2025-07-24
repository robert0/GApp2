//
//  LogWg.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI

struct LogView: View {
    @ObservedObject var viewModel = LogViewModel()
    // @State private var position = ScrollPosition(edge: .top)
    
    // The logs panel
    var body: some View {
        
        ScrollView() {
            VStack(alignment: HorizontalAlignment.leading) {
                Text("--- Logging (Trimmed) ---")
                Spacer()
                Text(viewModel.text).lineLimit(nil)
            }
        }.frame(maxWidth: 600)
            .border(Color.red)
        
    }
    
    // The logs panel
    func logCallbackFunction(_ message:String) {
        self.viewModel.text = message
    }
}

final class LogViewModel: ObservableObject {
    @Published var text = "UI Logging Initialized..."
}

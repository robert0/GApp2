//
//  PulsatingIcon.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation
import SwiftUI

struct ImagePulsate: View {
    @State private var uv = 1.0
    
    var body: some View {
        Image(systemName: "dot.radiowaves.left.and.right" )
            .foregroundColor(.blue)
            .opacity(uv)
        .onAppear {
//            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
//                uv = 0.3
//            }
        }
    }
}

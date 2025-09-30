//
//  TestWatchView.swift
//  GApp2
//
//  Created by Robert Talianu on 08.09.2025.
//


// TestWatchView.swift
import SwiftUI

struct TestWatchView: View {
    var body: some View {
        VStack {
            Text("Test watch:").italic()
            if !GApp2App.isWatchConnectivityActive() {
                Text("Warning: Watch connection is not active! Check bluetooth, network or verify the watch is also running the app.")
                    .foregroundColor(.gray)
                    .italic()
                    .font(.footnote)
            }
            HStack {
                Button("Send 3 Clicks") {
                    GApp2App.sendWatchAHapticMessage(HapticType.click3, ".click3")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!GApp2App.isWatchConnectivityActive())

                Button("Send Notification") {
                    GApp2App.sendWatchAHapticMessage(HapticType.notification, ".notification")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!GApp2App.isWatchConnectivityActive())
            }
        }
    }
}

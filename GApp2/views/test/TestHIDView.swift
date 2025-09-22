//
//  TestHIDView.swift
//  GApp2
//
//  Created by Robert Talianu on 08.09.2025.
//


// TestHIDView.swift
import SwiftUI

struct TestHIDView: View {
    @StateObject private var subscriptionManager = HIDPeripheralSubscriptionManager.shared

    var body: some View {
        VStack {
            Text("Test HID:").italic()
            HStack {
                Button("Send KeyTyped") {
                    GApp2App.sendHIDKeyTyped(keyCodes: [0x04])
                }
                .buttonStyle(.borderedProminent)

                Button("Send MouseMove") {
                    GApp2App.sendHIDMouseMove(dx: 10, dy: 10, buttons: 0)
                }
                .buttonStyle(.borderedProminent)
            }
            Divider()
            Text("HID Subscribers:")
            List(subscriptionManager.hidSubscribers, id: \.identifier) { central in
                Text(central.identifier.uuidString)
            }
        }
    }
}

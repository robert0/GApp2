//
//  TestView.swift
//  GApp2
//
//  Created by Robert Talianu
//


// TestView.swift
import SwiftUI

struct TestView: View {
    var analyser: RealtimeMultiGestureStoreAnalyser

    init(_ analyser:RealtimeMultiGestureStoreAnalyser) {
        Globals.log("Testing view, init() ...")
        self.analyser = analyser
    }
    var body: some View {
        TabView {
            TestGesturesView(analyser)
                .tabItem {
                    Label("Gestures", systemImage: "hand.point.up.left")
                }
            TestWatchView()
                .tabItem {
                    Label("Watch", systemImage: "applewatch")
                }
            TestHIDView()
                .tabItem {
                    Label("HID", systemImage: "keyboard")
                }
        }
    }
}

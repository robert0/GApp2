//
//  ContentView.swift
//  GApp2 Watch App
//
//  Created by Robert Talianu
//

import SwiftUI

struct WCContentView: View {

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to GWatch! ")
            
            Button("Activate Sensors", action: {
                SensorMgr.startAccelerometers(WDevice.View_Accelerometer_Interval)
            })
        }
        .padding()
    }
}

#Preview {
    WCContentView()
}

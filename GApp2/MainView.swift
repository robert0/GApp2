//
//  ContentView.swift
//  GApp2
//
//  Created by Robert Talianu
//

import SwiftUI

struct MainView: View {
    //logger view wg
    private var logView: LogView
    //initilize app vars
    private var analyser: RealtimeMultiGestureAnalyser
    private var keys = ["A", "B", "C"]
  
    init () {
        //initilize local vars
        self.logView = LogView()
        Globals.setChangeCallback(self.logView.logCallbackFunction)
        
        //Create & link Gesture Analyser
        analyser = RealtimeMultiGestureAnalyser(keys)
    }
    
    var body: some View {
          
            NavigationView {
                VStack {
                    Spacer()
                    NavigationLink(destination: CreateGestureView()) {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                        Text("Create Gesture")
                    }
                    Spacer().frame(height:30)
                    NavigationLink(destination: ManageGesturesView(keys, analyser)) {
                        Image(systemName: "pencil")
                            .imageScale(.large)
                        Text("Manage Gestures")
                    }
                    Spacer().frame(height:30)
                    NavigationLink(destination: TestGesturesView(keys, analyser)) {
                        Image(systemName: "play")
                            .imageScale(.large)
                        Text("Test")
                    }
                    Spacer()
                }
            }
            Spacer()
    }
}

#Preview {
    MainView()
}

//
//  ContentView.swift
//  GApp
//
//  Created by Robert Talianu on 03.10.2024.
//

import SwiftUI

struct AppRootView: View {
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
      
        TabView{
//            let av = AppTabView(keys, analyser)
//            av.tabItem {
//                Text("App")
//            }.tag(1)

            logView.tabItem {
                Text("Logs")
            }.tag(2)
           

            let btv = BTView(keys, analyser)
            btv.tabItem {
                Text("Bluetooth")
            }.tag(3)
        }

    }



}

#Preview {
    AppRootView()
}

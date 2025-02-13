//
//  GApp2App.swift
//  GApp2
//
//  Created by Robert Talianu
//

import SwiftUI

@main
struct GApp2App: App {
    static var watchDelegateConnector: WDConnector?
    //static var contentView:ContentView? = nil
    
    
    init() {
//        UserDefaults.standard.register(defaults: [
//            "name": "Taylor Swift",
//            "highScore": 10
//        ])
        
       //let dbls: [Double] = [1.001, 2.005, 3.009]
        
        //writeData(dbls)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    

    public static func activateWatchConnectivity() {
        if(GApp2App.watchDelegateConnector == nil){
            GApp2App.watchDelegateConnector = WDConnector()
        }
    }
    
    
    public static func sendWatchAMessage(_ msg:String) {
        if(GApp2App.watchDelegateConnector != nil){
            GApp2App.watchDelegateConnector?.sendDataToWatch(msg)
        }
    }
}

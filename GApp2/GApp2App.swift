//
//  GApp2App.swift
//  GApp2
//
//  Created by Robert Talianu
//

import SwiftUI

@main
struct GApp2App: App {
    
    init() {
//        UserDefaults.standard.register(defaults: [
//            "name": "Taylor Swift",
//            "highScore": 10
//        ])
        
       //let dbls: [Double] = [1.001, 2.005, 3.009]
        
        //writeData(dbls)
        
        
        let gestures = FileSystem.readLocalGesturesDataFile()
        Globals.log("gestures: \(gestures.count)")
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    

   
}

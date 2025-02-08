//
//  GApp2WatchApp.swift
//  GApp2 Watch App
//
//  Created by Robert Talianu
//

import SwiftUI

@main
struct GApp2Watch_Watch_AppApp: App {
    //static class used for easy access
    static var app:GApp2Watch_Watch_AppApp?
    static var buffer:GBuffer = GBuffer()
    
    //plug-in vars
    @WKApplicationDelegateAdaptor(WKAppDelegatePhoneConnector.self) var delegate: WKAppDelegatePhoneConnector
    
    var body: some Scene {
        WindowGroup {
            WCContentView()
        }
    }
    
    /*
     *
     */
    static func addToBuffer(_ data:String){
        buffer.append(data)
    }
    
    /*
     *
     */
    static func extractBuffer() -> String {
        return buffer.extract()
    }
}

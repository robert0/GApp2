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
    static var view:WCContentView?
    
    init() {
        GApp2Watch_Watch_AppApp.view = WCContentView()
    }
    
    var body: some Scene {
        WindowGroup {
            GApp2Watch_Watch_AppApp.view
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
    
    /*
     *
     */
    static func showMessage(_ msg:String){
        if(msg == ".click"){
            WKInterfaceDevice.current().play( WKHapticType.click)
            
        } else if(msg == ".click2"){
            WKInterfaceDevice.current().play( WKHapticType.click)
            Thread.sleep(forTimeInterval: 0.1)
            WKInterfaceDevice.current().play( WKHapticType.click)

            
        } else if(msg == ".click3"){
            WKInterfaceDevice.current().play( WKHapticType.click)
            Thread.sleep(forTimeInterval: 0.1)
            WKInterfaceDevice.current().play( WKHapticType.click)
            Thread.sleep(forTimeInterval: 0.1)
            WKInterfaceDevice.current().play( WKHapticType.click)
            
        } else if(msg == ".failure"){
            WKInterfaceDevice.current().play( WKHapticType.failure)
            
        } else if(msg == ".notification"){
            WKInterfaceDevice.current().play( WKHapticType.notification)
            
        } else {
            WKInterfaceDevice.current().play( WKHapticType.success)
        }
       
        GApp2Watch_Watch_AppApp.view?.showMessage(msg)
    }
}

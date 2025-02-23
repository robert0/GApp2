//
//  GApp2App.swift
//  GApp2
//
//  Created by Robert Talianu
//

import SwiftUI
import CoreBluetooth

@main
struct GApp2App: App {
    static var watchDelegateConnector: WDConnector?
    static var btoInstance:BTObject?
    static var btPeripheralDevice:CBPeripheral?
  
    
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
    
    /*
     *
     */
    public static func startBT() -> BTObject? {
        Globals.log("APP_Main:startBT() called..")
        if(GApp2App.btoInstance == nil){
            GApp2App.btoInstance = BTObject()//self start scanning
        }
        return GApp2App.btoInstance
    }
    
    /*
     *
     */
    public static func pairToBTDevice(_ cbp:CBPeripheral) {
        Globals.log("APP_Main:pairToBTDevice() called..")
        if(GApp2App.btPeripheralDevice == nil){
            GApp2App.btPeripheralDevice = cbp
            //TODO... start stream to cbp
            //TODO... maybe stop scannning after the connection took place
        }
    }
    
    /*
     *
     */
    public static func sendPairedBTDeviceAMessage(_ msg:String) {
        //TODO...
    }
}

//
//  GApp2App.swift
//  GApp2
//
//  Created by Robert Talianu
//

import SwiftUI
import CoreBluetooth

public enum ActionType: String, CaseIterable, Identifiable {
    case executeCommand = "Execute Command"
    case forwardViaBluetooth = "Send via Bluetooth"
    case executeCmdAndForwardViaBluetooth = "Execute Command and Send via Bluetooth"
    public var id: Self { self }
}


@main
struct GApp2App: App {
    static var watchDelegateConnector: WDConnector?
    static var btoInstance:BTPeripheralObj?
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
       
    /*
     *
     */
    public static func activateWatchConnectivity() {
        if(GApp2App.watchDelegateConnector == nil){
            GApp2App.watchDelegateConnector = WDConnector()
        }
    }
    
    /*
     *
     */
    public static func sendWatchAMessage(_ msg:String) {
        if(GApp2App.watchDelegateConnector != nil){
            GApp2App.watchDelegateConnector?.sendDataToWatch(msg)
        }
    }
    
    /*
     *
     */
    public static func startBT() -> BTPeripheralObj? {
        Globals.log("APP_Main:startBT() called..")
        if(GApp2App.btoInstance == nil){
            GApp2App.btoInstance = BTPeripheralObj()//self start scanning
        }
        return GApp2App.btoInstance
    }
    
    /*
     *
     */
    public static func startBTScanning() {
        Globals.log("APP_Main:startBTScanning() called..")
        if(GApp2App.btoInstance != nil){
            GApp2App.btoInstance!.startScan()
            
        } else {
            Globals.log("APP_Main:advertiseMessage failed; No btoInstance")
        }
    }
    
    /*
     *
     */
    public static func pairToBTDevice(_ cbp:CBPeripheral) {
        Globals.log("APP_Main:pairToBTDevice() called..")
        
        //store locally
        GApp2App.btPeripheralDevice = cbp
        
        //connecting to a peripheral will automatically stop the current scanning
        GApp2App.btoInstance?.connectToPeripheral(cbp)
        
    }
    
    /*
     *
     */
    public static func advertiseMessage(_ msg:String) {
        Globals.log("APP_Main:advertiseMessage() called..")
        if(GApp2App.btoInstance != nil){
            GApp2App.btoInstance!.advertiseText(msg)
            
        } else {
            Globals.log("APP_Main:advertiseMessage failed; No btoInstance")
        }
    }
    
    /*
     *
     */
//    public static func sendMessageToPairedBTDevice(_ msg:String) {
//        Globals.log("APP_Main:sendMessageToPairedBTDevice() called..")
//        //TODO .. verify that we are paired to a device
//        if( GApp2App.btPeripheralDevice != nil ){
//            GApp2App.btoInstance?.sendText(msg)
//            
//        } else {
//            Globals.log("APP_Main:sendMessageToPairedBTDevice failed; No paired device")
//        }
//    }
    
    /*
     *
     */
    public static func enableBluetoothListening(){
        //TODO ...
    }
    
    /*
     *
     */
    public static func disableBluetoothListening(){
        //TODO ...
    }
}

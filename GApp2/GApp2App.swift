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
    static var btOutInstance:BTPeripheralObj_OUT?
    static var btInInstance:BTCentralObj_IN?
    static var btPeripheralDevice:CBPeripheral?  
    
    //static var contentView:ContentView? = nil
    
    
    init() {
//        UserDefaults.standard.register(defaults: [
//            "name": "Taylor Swift",
//            "highScore": 10
//        ])
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
    public static func startBTOutbound() -> BTPeripheralObj_OUT? {
        Globals.log("APP_Main:startBTOutbound() called..")
        if(GApp2App.btOutInstance == nil){
            GApp2App.btOutInstance = BTPeripheralObj_OUT()//self start scanning
        }
        return GApp2App.btOutInstance
    }
    
    /*
     *
     */
    public static func startBTInbound() -> BTCentralObj_IN? {
        Globals.log("APP_Main:startBT() called..")
        if(GApp2App.btInInstance == nil){
            GApp2App.btInInstance = BTCentralObj_IN()//self start scanning
        }
        return GApp2App.btInInstance
    }
    
    /*
     *
     */
    public static func startBTScanning() {
        //Globals.log("APP_Main:startBTScanning() called..")
        if(GApp2App.btInInstance != nil){
            GApp2App.btInInstance!.startScan()
            
        } else {
            Globals.log("APP_Main:startBTScanning failed; No btInInstance")
        }
    }
    
    /*
     *
     */
    public static func stopBTScanning() {
        //Globals.log("APP_Main:stopBTScanning() called..")
        if(GApp2App.btInInstance != nil){
            GApp2App.btInInstance!.stopScanning()
            
        } else {
            Globals.log("APP_Main:stopBTScanning failed; No btInInstance")
        }
    }
    
    /*
     *
     */
    public static func connectToBTDevice(_ cbp:CBPeripheral) {
        Globals.log("APP_Main:connectToBTDevice() called..")
        
        //store locally
        GApp2App.btPeripheralDevice = cbp
        
        //connecting to a peripheral will automatically stop the current scanning
        GApp2App.btInInstance?.connectToPeripheral(cbp)
        
    }
    
    /*
     *
     */
    public static func advertiseMessage(_ msg:String) {
        Globals.log("APP_Main:advertiseMessage() called..")
        if(GApp2App.btOutInstance != nil){
            GApp2App.btOutInstance!.advertiseText(msg)
            
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

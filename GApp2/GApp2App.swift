//
//  GApp2App.swift
//  GApp2
//
//  Created by Robert Talianu
//

import CoreBluetooth
import SwiftUI

public enum ActionType: String, CaseIterable, Identifiable {
    case executeCommand = "Execute Command Locally"
    case executeCmdViaSSH = "Execute Command via SSH"
    case executeCmdViaBluetooth = "Forward Gesture/Command via Bluetooth"

    public var id: Self { self }
    
    // Convert to string to display in menus and pickers.
    func stringValue() -> String {
        return rawValue
    }
}

@main
struct GApp2App: App {
    static var gestureDispatcher: GestureDispatcher = GestureDispatcher()
    static var wdConnector: WDConnector?
    static var btOutInstance: BTPeripheralObj_OUT?
    static var btInInstance: BTCentralObj_IN?
    static var mpbc: HIDBluetoothController?
    static var btPeripheralDevice: CBPeripheral?
    private static var sshDataBean: SshDataBean?
    static var lastSshCmd: String? = nil
        
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
    
    /**
     * Displays a toast message with the specified severity.
     */
    static func showToastMessage(_ message: String, _ severity: ToastSeverity) {
        ToastManager.show(message, severity)
    }
    
    /**
     * Connects to the SSH server using the SSHConnector.
     */
    public static func connectToSSHServer() {
        Globals.log("APP_Main: Connecting to SSH Server (authenticating) ...")
        SSHConnector.authenticate()
    }
    
    /// Sets the SSH data bean
    public static func setSshDataBean(_ bean: SshDataBean) {
        GApp2App.sshDataBean = bean
        SSHConnector.initialize(sshDataBean: bean)
    }
    
    /// Sets the SSH data bean with the provided hostname, username, and password.
    public static func setSshDataBean(_ hostname: String, _ username: String, _ password: String) {
        if GApp2App.sshDataBean == nil {
            GApp2App.sshDataBean = SshDataBean()
        }
        sshDataBean?.hostname = hostname
        sshDataBean?.username = username
        sshDataBean?.password = password
        
        SSHConnector.initialize(sshDataBean: self.sshDataBean!)
    }
    
    /// Retrieves the SSH data bean.
    public static func getSshDataBean() -> SshDataBean? {
        return GApp2App.sshDataBean
    }
    
    //get ssh server name from sshdatabean
    public static func getSshServerName() -> String? {
        return GApp2App.sshDataBean?.hostname
    }
    
    
    /// Executes a command via SSH using the SSHConnector.
    public static func executeCommandViaSSH(_ cmd: String) -> String? {
        if GApp2App.sshDataBean != nil {
            lastSshCmd = cmd
            return SSHConnector.executeCommand(cmd)
        } else {
            Globals.log("APP_Main:executeCommandViaSSH failed; SSH is not configured!")
            return nil
        }
    }
    
    /// Retrieves the last executed SSH command.
    public static func getLastSshCommand() -> String? {
        return GApp2App.lastSshCmd
    }
            
    /*
     *
     */
    public static func startBTOutbound() -> BTPeripheralObj_OUT? {
        Globals.log("APP_Main: Starting Bluetooth Outbound...")
        if GApp2App.btOutInstance == nil {
            GApp2App.btOutInstance = BTPeripheralObj_OUT()  //self start scanning
            //mpbc = MPBluetoothController()
        }
        return GApp2App.btOutInstance
    }

    /*
     *
     */
    public static func startBTInbound() -> BTCentralObj_IN? {
        Globals.log("APP_Main: Starting Bluetooth Inbound...")
        if GApp2App.btInInstance == nil {
            GApp2App.btInInstance = BTCentralObj_IN()  //self start scanning
            GApp2App.btInInstance?.addBTChangeListener(gestureDispatcher)
        }
        return GApp2App.btInInstance
    }

    /**
     *
     */
    public static func addBTChangeListener(_ btl: BTChangeListener) {
        if GApp2App.btInInstance != nil {
            GApp2App.btInInstance!.addBTChangeListener(btl)

        } else {
            Globals.log("APP_Main:addBTChangeListener failed; No btInInstance")
        }
    }

    /*
     *
     */
    public static func startBTScanning() {
        Globals.log("APP_Main: Starting Bluetooth Scanning...")
        if GApp2App.btInInstance != nil {
            GApp2App.btInInstance!.startScan()

        } else {
            Globals.log("APP_Main:startBTScanning failed; No btInInstance")
        }
    }

    /*
     *
     */
    public static func stopBTScanning() {
        Globals.log("APP_Main: Stopping Bluetooth Scanning...")
        if GApp2App.btInInstance != nil {
            GApp2App.btInInstance!.stopScanning()

        } else {
            Globals.log("APP_Main:stopBTScanning failed; No btInInstance")
        }
    }

    /*
     *
     */
    public static func connectToBTDevice(_ cbp: CBPeripheral) {
        Globals.log("APP_Main: Connecting to Bluetooth Peripheral...")

        //store locally
        GApp2App.btPeripheralDevice = cbp

        //connecting to a peripheral will automatically stop the current scanning
        GApp2App.btInInstance?.connectToPeripheral(cbp)

    }

    /*
     *
     */
    public static func advertiseMessage(_ msg: String) {
        Globals.log("APP_Main: Advertising Message via Bluetooth ...")
        if GApp2App.btOutInstance != nil {
            ToastManager.show("Out: Bluetooth message... ", ToastSeverity.success)
            GApp2App.btOutInstance!.advertiseText(msg)

        } else {
            Globals.log("APP_Main:advertiseMessage failed; No btoInstance")
        }
    }

    /*
     *
     */
    public static func advertiseData(_ data: Data) {
        Globals.log("APP_Main: Advertising Data via Bluetooth ...")
        if GApp2App.btOutInstance != nil {
            ToastManager.show("Out: Bluetooth data... ", ToastSeverity.success)
            GApp2App.btOutInstance!.advertiseData(data)

        } else {
            Globals.log("APP_Main:advertiseData failed; No btoInstance")
        }
    }

    /*
     *
     */
    public static func enableBluetoothListening() {
        //TODO ...
    }

    /*
     *
     */
    public static func disableBluetoothListening() {
        //TODO ...
    }
    
    
    /*
     *
     */
    public static func activateWatchConnectivity() {
        Globals.log("APP_Main: Activating Watch Connectivity...")
        if GApp2App.wdConnector == nil {
            GApp2App.wdConnector = WDConnector()
        }
    }
    
    /*
     *
     */
    public static func sendWatchAMessage(_ topic: String, _ msg: String) {
        Globals.log("APP_Main: sendWatchAMessage...")
        if GApp2App.wdConnector != nil {
            GApp2App.wdConnector?.sendDataToWatch(topic, msg)
        }
    }
    
    /*
     *
     */
    public static func deactivateWatchSensors(){
        Globals.log("APP_Main: Deactivating Watch Sensors ...")
        sendWatchAMessage(Device.Watch_Phone_Topic_STATE_Key, "deactivateSensors")
    }
    
    /*
     *
     */
    public static func activateWatchSensors() {
        Globals.log("APP_Main: Activating Watch Sensors ...")
        sendWatchAMessage(Device.Watch_Phone_Topic_STATE_Key, "activateSensors")
    }
    
    
    public static func isWatchConnectivityActive() -> Bool {
        return GApp2App.wdConnector != nil && GApp2App.wdConnector!.session.isReachable
    }
       

}

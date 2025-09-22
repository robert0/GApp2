//
//  GApp2WatchApp.swift
//  GApp2 Watch App
//
//  Created by Robert Talianu
//

import SwiftUI

@main
struct GApp2Watch_Watch_AppApp: App {
    //create self initialized singleton
    private static var app = GApp2Watch_Watch_AppApp()
    private static var wkMgr:WorkoutManager = WorkoutManager()
    private var buffer:GBuffer = GBuffer()
    private var sensorStreaming:Bool = false
    private var dataTransferTimer: Timer?
    private static var view:WCContentView?
    
    //plug-in vars
    @WKApplicationDelegateAdaptor(WKAppDelegatePhoneConnector.self) var delegate: WKAppDelegatePhoneConnector

    init() {
        //create the view
        GApp2Watch_Watch_AppApp.view = WCContentView()
    }
    
    var body: some Scene {
        WindowGroup {
            GApp2Watch_Watch_AppApp.view
        }
    }
    
    
    /**
      * Starts the data transfer timer which periodically sends data to the iOS app.
     */
    public static func startDataTransferTimer() {
         print("GWatchApp_Watch_AppApp: Starting data dispatch timer...")
         
         // Start the timer to send data periodically
        if(app.dataTransferTimer == nil) {
             print("GWatchApp_Watch_AppApp: Creating update timer...")
            var countStart = 0
            app.dataTransferTimer = Timer.scheduledTimer(withTimeInterval: WDevice.Phone_Update_Interval, repeats: true) { _ in
                if(countStart < 1){
                    countStart = countStart + 1
                    print("GWatchApp_Watch_AppApp Timer is Started. First tick... ")
                }
                 //get buffer and clear it
                 var cdata =  GApp2Watch_Watch_AppApp.consumeBuffer()
                 if( cdata.last == ","){
                     cdata.removeLast()
                 }
                 
                 //only send data if the sensors are allowed to stream data
                 if(GApp2Watch_Watch_AppApp.isSensorStreaming()) {
                     //print("WKAppConnector: >>>>>>> sending data... \(String(describing: app.delegate))")
                     // send as an array of Sample4D encoded
                     let dict: [String : Any] = ["data": "[" + cdata + "]"]
                     app.delegate.sendMessage(dict, replyHandler: nil)
                 }
             }
         }
    }
    
    /*
     *
     */
    static func addToBuffer(_ data:String){
        app.buffer.append(data)
    }
    
    /*
     *
     */
    static func consumeBuffer() -> String {
        return app.buffer.consume()
    }
    
    // MARK: - Sensor Streaming ENABLED
    public static func activateSensorStreaming(){
        app.sensorStreaming = true
        wkMgr.startWorkout()
    }
    
    // MARK: - Sensor Streaming DISABLED
    public static func deactivateSensorStreaming(){
        app.sensorStreaming = false
        wkMgr.stopWorkout()
    }
    
    // MARK: - Sensor Streaming STATUS
    public static func isSensorStreaming() -> Bool {
        return app.sensorStreaming
    }
    
    /*
     * Shows messages and plays a Haptic
     */
    static func showHapticMessage(_ msg:String){
        print("GApp2Watch_Watch_AppApp -> showHapticMessage: \(msg)")
        let parts = msg.components(separatedBy: WDevice.Watch_Phone_Topic_HMSG_Separator)
        let haptic = parts[0]
        let message = parts[1]
        
        //extract htype from message
        let htype = HapticType.from(haptic)
        if(htype != nil) {
            htype!.play()
        }
        
        //only show a message if available
        if(!message.isEmpty ){
            GApp2Watch_Watch_AppApp.view?.showMessage(message)
        }
    }
    
    /*
     * Only shows messages on watch screen
     */
    static func showMessage(_ msg:String){
        print("GApp2Watch_Watch_AppApp -> showMessage: \(msg)")
        GApp2Watch_Watch_AppApp.view?.showMessage(msg)
    }
}

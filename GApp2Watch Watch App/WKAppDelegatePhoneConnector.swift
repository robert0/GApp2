//
//  WCConnector.swift
//  GApp2 Watch App
//
//  Created by Robert Talianu
//

import Foundation
import WatchConnectivity
import WatchKit

public class WKAppDelegatePhoneConnector : NSObject, WCSessionDelegate, WKApplicationDelegate {
    let session = WCSession.default
    
    /*
     *
     */
    public func applicationDidBecomeActive(){
        print("Watch App: applicationDidBecomeActive. Starting WCSession...")
        
        // Perform any final initialization of your application.
        if WCSession.isSupported() {
            print("WKConnector: WCSession is supported! Activating session...")
            let session = WCSession.default
            session.delegate = self
            session.activate()

        } else {
            print("WKConnector: WCSession is not supported.")
        }
    }
    
    /*
     *
     */
    public func applicationWillEnterForeground(){
        print("Watch App: applicationWillEnterForeground!")
    }
    
    /*
     *
     */
    public func applicationDidEnterBackground(){
        print("Watch App: applicationDidEnterBackground!")
    }
    
    /*
     *
     */
    public func applicationDidFinishLaunching() {
        print("Watch App: applicationDidFinishLaunching. Starting Accelerometers. Starting data transfer Timer")
        print("Watch App: Starting Accelerometers...")
        print("Watch App: Starting data transfer Timer...")
        SensorMgr.startAccelerometers()
        GApp2Watch_Watch_AppApp.startDataTransferTimer()
    }
    
    /*
     * Called when the session is activated
     */
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WKConnector: WCSession - Activation completed with state: \(activationState)")
        if let error {
            print("WKConnector: WCSession activation FAILED with error: \(error.localizedDescription)")
            return
        }
        
        printState(session)
    }
    
    /*
     * @param session
     */
    fileprivate func printState(_ session: WCSession) {
        if(session.activationState == .activated) {
            print("WKConnector: WCSession is ACTIVATED")
            
        } else if(session.activationState == .inactive) {
            print("WKConnector: WCSession is INACTIVE")
            
        } else if(session.activationState == .notActivated) {
            print("WKConnector: WCSession is NOT ACTIVATED")
            
        }
        print("WKConnector: WCSession is \(session.isReachable ? "REACHABLE":"NOT REACHABLE (check bluetooth is active or network is the same; check iphone and iwatch apps are complementary apps)") ")
    }
    
    /*
     * @param session
     * @param message
     */
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("WKConnector: WCSession got message: \(message.debugDescription)")
        MessageRouter.dispatchMessages(message)
    }
    
    /*
     *
     */
//    func sendDataToPhone() {
//        print("Watch: >>>>>>> sending data to iphone...")
//        var cdata =  GApp2Watch_Watch_AppApp.consumeBuffer()
//        if( cdata.last == ","){
//            cdata.removeLast()
//        }
//        let dict: [String : Any] = ["data": "[" + cdata + "]"]// send as an array of Sample4D encoded
//        session.sendMessage(dict, replyHandler: nil)
//    }
    
    public func sendMessage(_ message: [String : Any], replyHandler: (([String : Any]) -> Void)?, errorHandler: ((any Error) -> Void)? = nil){
        print("WKConnector:  send message... \(session.isReachable) _data_ \(message.count)")
        session.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
}

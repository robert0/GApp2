//
//  WkDg.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation
import WatchConnectivity
import SwiftUICore

public class WDConnector : NSObject, WCSessionDelegate {
    var session = WCSession.default
    var counter = 1
    
    public override init(){
        super.init()
        print("WDConnector init...")
        
        // Perform any final initialization of your application.
        if WCSession.isSupported() {
            print("WDConnector: WCSession is supported! Activating session...")
            session = WCSession.default
            session.delegate = self
            session.activate()

        } else {
            print("WDConnector: WCSession is not supported.")
        }
    }
    
    // Called when needs to print state of session
    public static func printState(_ session: WCSession) {
        if(session.activationState == .activated) {
            print("WDConnector: WCSession is ACTIVATED")
            
        } else if(session.activationState == .inactive) {
            print("WDConnector: WCSession is INACTIVE")
            
        } else if(session.activationState == .notActivated) {
            print("WDConnector: WCSession is NOT ACTIVATED")
            
        }
        print("WDConnector: WCSession is \(session.isPaired ? "PAIRED":"NOT PAIRED") ")
        print("WDConnector: WCSession is \(session.isReachable ? "REACHABLE":"NOT REACHABLE (check bluetooth is active or network is the same; check iphone and iwatch apps are complementary apps)") ")
        print("WDConnector: WCSession.isWatchAppInstalled: \(session.isWatchAppInstalled)")
    }
    
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WDConnector: WCSession - Activation completed with state: \(activationState)")
        if let error {
            print("WDConnector: WCSession activation FAILED with error: \(error.localizedDescription)")
            return
        }
        
        WDConnector.printState(session)
    }
           
    /** Called on the delegate of the receiver. Will be called on startup if the incoming message caused the receiver to launch. */
    //    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]){
    //        print("WDConnector: WCSession didReceiveMessage message: \(message.description)\(counter)")
    //    }
    
    /** Called on the delegate of the receiver when the sender sends a message that expects a reply. Will be called on startup if the incoming message caused the receiver to launch. */
    //    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void){
    //        print("WDConnector: WCSession didReceiveMessage/reply message: \(message.description)\(counter)")
    //    }
    
    /** Called on the delegate of the receiver. Will be called on startup if the incoming message data caused the receiver to launch. */
    //    public func session(_ session: WCSession, didReceiveMessageData messageData: Data){
    //        print("WDConnector: WCSession didReceiveMessageData  message")
    //    }
    
    /** Called on the delegate of the receiver when the sender sends message data that expects a reply. Will be called on startup if the incoming message data caused the receiver to launch. */
    //    public func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void){
    //        print("WDConnector: WCSession didReceiveMessageData/reply message")
    //    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //print("WDConnector: WCSession incomming message: \(message.count)\(counter)")
        guard let data: String = message["data"] as? String else { return }
        //print("iPhone: got message from watch: \(data)\(counter)")
        
        RawGestureDeviceRouter.routeData(DeviceType.Watch, data)//of type String
        
        counter += 1
    }
    
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("WDConnector: sessionDidBecomeInactive called. Reactivating session...")
        session.activate()
    }

    public func sessionDidDeactivate(_ session: WCSession) {
        print("WDConnector: sessionDidDeactivate called. Reactivating session...")
        session.activate()
    }
    
    
    public func sendDataToWatch(_ topic: String, _ text: String) {
        print("WDConnector: sendDataToWatch() -> WCSession activeState: \(session.activationState)")
        
        session.sendMessage([topic: text], replyHandler: nil, errorHandler: { error in
            print("WDConnector: Failed to send message to watch: \(error.localizedDescription)")
        })
    }

    /** Called when any of the Watch state properties change. */
    public func sessionWatchStateDidChange(_ session: WCSession){
        print("WDConnector: WCSession sessionWatchStateDidChange() called")
        WDConnector.printState(session)
    }

    /** Called when the reachable state of the counterpart app changes. The receiver should check the reachable property on receiving this delegate callback. */
    public func sessionReachabilityDidChange(_ session: WCSession){
        print("WDConnector: WCSession sessionReachabilityDidChange() called")
        WDConnector.printState(session)
    }
}

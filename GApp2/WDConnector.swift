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
    let session = WCSession.default
    var counter = 1
    
    public override init(){
        super.init()
        print("iPhone: WKAppDelegateWatchConnector.init()!")
        
        // Perform any final initialization of your application.
        if WCSession.isSupported() {
            print("iPhone: WCSession is supported! Activating session...")
            let session = WCSession.default
            session.delegate = self
            session.activate()

        } else {
            print("iPhone: WCSession is not supported.")
        }
    }

    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("iPhone: session metod called when activationDidCompleteWith...\(activationState)")
        if let error {
            print("iPhone: session activation failed with error: \(error.localizedDescription)")
            return
        }
        
        if session.isReachable {
            print("iPhone: your iphone is Reachable")
        } else {
            print("iPhone: your iphone is not Reachable...")
        }
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let data: String = message["data"] as? String else { return }
        //print("iPhone: got message from watch: \(data)\(counter)")
        DeviceRouter.routeData(DeviceType.Watch, data)//of type String
        counter += 1
    }
    
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        session.activate()
    }

    public func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    
    public func sendDataToWatch(_ text:String) {
        //let text = "This message is from phone..."
        session.sendMessage(["iPhone": text], replyHandler: nil, errorHandler: nil)
    }

    // Called when session.reachable value changes, such as when a user wearing an Apple Watch gets out of range of their iPhone.
    
    /** Called when any of the Watch state properties change. */
    public func sessionWatchStateDidChange(_ session: WCSession){
        print("iPhone: sessionWatchStateDidChange() called")
        print("iPhone: Session is Paired (\(session.isPaired))")
        print("iPhone: Session is Reachable (\(session.isReachable))")
    }

    /** Called when the reachable state of the counterpart app changes. The receiver should check the reachable property on receiving this delegate callback. */
    public func sessionReachabilityDidChange(_ session: WCSession){
        print("iPhone: sessionReachabilityDidChange() called")
        if session.isReachable {
            print("iPhone: your iphone is Reachable")
        } else {
            print("iPhone: your iphone is not Reachable...")
        }
    }
}

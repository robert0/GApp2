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
    private static var timer: Timer?
    
    /*
     *
     */
    public func applicationDidBecomeActive(){
        print("Watch: applicationDidBecomeActive!")
        
        
        if(WKAppDelegatePhoneConnector.timer == nil) {
            WKAppDelegatePhoneConnector.timer = Timer.scheduledTimer(withTimeInterval: WDevice.Phone_Update_Interval, repeats: true) { _ in
                print("tick... ")
                self.sendDataToPhone()
            }
        }
        
        // Perform any final initialization of your application.
        if WCSession.isSupported() {
            print("Watch: WCSession is supported! Activating session...")
            let session = WCSession.default
            session.delegate = self
            session.activate()

        } else {
            print("Watch: WCSession is not supported.")
        }
    }
    
    /*
     *
     */
    public func applicationWillEnterForeground(){
        print("Watch: applicationWillEnterForeground!")
    }
    
    /*
     *
     */
    public func applicationDidEnterBackground(){
        print("Watch: applicationDidEnterBackground!")
    }
    
    /*
     *
     */
    public func applicationDidFinishLaunching() {
        print("Watch: applicationDidFinishLaunching!")
    }
    
    /*
     *
     *
     */
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch: session metod called when activationDidCompleteWith...\(activationState)")
        if let error {
            print("Watch: session activation failed with error: \(error.localizedDescription)")
            return
        }
        
        if session.isReachable {
            print("Watch: your iphone is Reachable")
        } else {
            print("Watch: your iphone is not Reachable...")
        }
        
        // send data
        sendDataToPhone()
        
    }
    
    /*
     * @param session
     * @param message
     */
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
      if let value = message["iPhone"] as? String {
          print("Watch: got message:" + value)
          GApp2Watch_Watch_AppApp.showMessage(value)
      }
    }
    
    /*
     *
     */
    func sendDataToPhone() {
        print("Watch: >>>>>>> sending data to iphone...")
        var cdata =  GApp2Watch_Watch_AppApp.extractBuffer()
        if( cdata.last == ","){
            cdata.removeLast()
        }
        let dict: [String : Any] = ["data": "[" + cdata + "]"]// send as an array of Sample4D encoded
        session.sendMessage(dict, replyHandler: nil)
    }
    
}

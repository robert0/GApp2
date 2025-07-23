//
//  MessageRouter.swift
//  GApp2Watch Watch App
//
//  Created by Robert Talianu
//

import Foundation


public class MessageRouter {
    
    
    public static func dispatchMessages(_ messages:[String : Any]) {
        // Default implementation does nothing
        if let value = messages[WDevice.Watch_Phone_Topic_STATE_Key] as? String {
           print("MessageRouter: State message received: \(value)")
            if(value == "activateSensors") {
                GApp2Watch_Watch_AppApp.activateSensorStreaming()
                
            } else if(value == "deactivateSensors") {
                GApp2Watch_Watch_AppApp.deactivateSensorStreaming()
                
            }

            
        } else  if let value = messages[WDevice.Watch_Phone_Topic_TXT_Key] as? String {
            GApp2Watch_Watch_AppApp.showMessage(value)
        }
        
    }
    
}
    

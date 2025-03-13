//
//  GestureDispatcher.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

//
// This class handles the realtime gesture dispatching once a gesture is found
//
public class GestureDispatcher : GestureEvaluationListener {
    private let correlationFactorFormat: String = " %.3f"//add space first for good JSON formatting
    
    
    var gesturesStore:MultiGestureStore
    var inGesturesStore:InGestureStore
    

    public init (_ gesturesStore:MultiGestureStore, _ inGesturesStore:InGestureStore){
        self.gesturesStore = gesturesStore
        self.inGesturesStore = inGesturesStore
    }
    
       
    //internal gestures that need to be dispatched - either executing commands or send via BT to other devices, or both
    public func gestureEvaluationCompleted(_ gw: GestureWindow, _ status: GestureEvaluationStatus) {
        let gkey = status.getGestureKey();
        let gCorr = status.getGestureCorrelationFactor();
        
        let gesture:Gesture4D? = gesturesStore.getGesture(gkey) ?? nil
        if (gesture != nil) {
            if(gesture?.getActionType() == ActionType.forwardViaBluetooth){
                Globals.log("GestureDispatcher:Forwarding gesture viw BT...")
                let gCorrFt = String(format: self.correlationFactorFormat, gCorr)
                let jsonDataStr = "{\"gestureKey\":\"\(gkey)\", \"gestureCorrelationFactor\":\(gCorrFt)}"
                GApp2App.advertiseMessage(jsonDataStr)
                
            } else  if(gesture?.getActionType() == ActionType.executeCommand){
                Globals.log("GestureDispatcher:Executing gesture command ...")
                //CommandExecutor.executeCommand(gesture?.getCommand())
                
            } else  if(gesture?.getActionType() == ActionType.executeCmdAndForwardViaBluetooth){
                Globals.log("GestureDispatcher:Executing gesture command ...")
                //CommandExecutor.executeCommand(gesture?.getCommand())
                Globals.log("GestureDispatcher:Forwarding gesture viw BT...")
                let gCorrFt = String(format: self.correlationFactorFormat, gCorr)
                let jsonDataStr = "{\"gestureKey\":\"\(gkey)\", \"gestureCorrelationFactor\":\(gCorrFt)}"
                GApp2App.advertiseMessage(jsonDataStr)
            }
        }
    }
    
}

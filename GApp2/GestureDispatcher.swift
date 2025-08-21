//
//  GestureDispatcher.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation
import CoreBluetooth

//
// This class handles the realtime gesture dispatching once a gesture is found
//
public class GestureDispatcher : GestureEvaluationListener, BTChangeListener {

    private let correlationFactorFormat: String = " %.3f"//add space first for good JSON formatting
    var gesturesStore:MultiGestureStore?
    var inGesturesStore:InGestureStore?
    

    public init (){
    }
    
    public func setGestureStore(_ gesturesStore:MultiGestureStore){
        self.gesturesStore = gesturesStore
    }
    
    public func setInGestureStore(_ inGesturesStore:InGestureStore){
        self.inGesturesStore = inGesturesStore
    }
       

    // event via GestureEvaluationListener
    public func gestureEvaluationCompleted(_ gw: GestureWindow, _ status: GestureEvaluationStatus) {
        let gkey = status.getGestureKey()
        let gCorr:Double = status.getGestureCorrelationFactor()
        
        let gesture:Gesture4D? = gesturesStore?.getGesture(gkey) ?? nil
        if (gesture != nil && gCorr >= (gesture?.getActionThreshold())!) {
            if(gesture?.getActionType() == ActionType.executeCommand){
                Globals.log("GestureDispatcher:Executing gesture command ...")
                //CommandExecutor.executeCommand(gesture?.getCommand())
                
            } else  if(gesture?.getActionType() == ActionType.executeCmdViaBluetooth){
                Globals.log("GestureDispatcher:Executing gesture command via BT...")
                
                //send to bluetooth
                sendViaBluetooth(gCorr, gesture!)
            } else  if(gesture?.getActionType() == ActionType.executeCmdViaSSH){
                Globals.log("GestureDispatcher:Executing gesture command via SSH...")
                
                //execute via SSH
                executeViaSSH(gCorr, gesture!)
            } else  if(gesture?.getActionType() == ActionType.executeAsHID){
                Globals.log("GestureDispatcher:Executing gesture command as HID key event...")
                
                //execute via SSH
                executeAsHID( gesture!)
            }
        }
    }
    
    // event via GestureEvaluationListener
    fileprivate func sendViaBluetooth(_ gCorr: Double, _ gesture: Gesture4D) {
        
        Globals.log("GestureDispatcher:Forwarding gesture viw BT...")
        let gCorrFt = String(format: self.correlationFactorFormat, gCorr)
        let cutCorrFt:Double = floor(gCorr * 1000.0)/1000.0
        sendViaBluetooth(gesture.getName(), cutCorrFt, gesture.getCommand())
    }
    
    
    // init(_ gestureKey: String, _ gestureCorrelationFactor: Double, _ gestureCommand: String) {
    fileprivate func sendViaBluetooth(_ gestureKey: String, _ gestureCorrelationFactor: Double, _ gestureCommand: String) {
        let gs:GestureJson = GestureJson(gestureKey, gestureCorrelationFactor, gestureCommand )
        
        do {
            let encoder = JSONEncoder()
            //encoder.outputFormatting = .prettyPrinted
            //encoder.keyEncodingStrategy = .convertToSnakeCase
            //encoder.dateEncodingStrategy = .iso8601
            //encoder.dataEncodingStrategy = .base64
            let egs = try encoder.encode(gs)
            
            //send data via Bluetooth
            GApp2App.advertiseData(egs)
            Globals.log("GestureDispatcher:send gesture: {\(gs.gestureKey):\(gs.gestureCorrelationFactor)}")
            
        } catch {
            Globals.log("GestureDispatcher: Error encoding to JSON: \(error)")
        }
    }
    
    //
    fileprivate func executeViaSSH(_ gCorr: Double, _ gesture: Gesture4D) {
        
        Globals.log("GestureDispatcher: Executing command via SSH...")
        let gCorrFt = String(format: self.correlationFactorFormat, gCorr)
        let cutCorrFt:Double = floor(gCorr * 1000.0)/1000.0
        let cmd = gesture.getCommand()
        // execute command via SSH
        var response: String? = GApp2App.executeCommandViaSSH(cmd)
    }
    
    //
    fileprivate func executeAsHID(_ gesture: Gesture4D) {
        Globals.log("GestureDispatcher: Executing command via SSH...")
        let hidParts = gesture.getHIDCommand().split(separator: Device.HID_Modifiers_Keycode_Separator)
        let keyCode = UInt8(hidParts[1])!
        let modifiers = UInt8(hidParts[0])!
        
        // execute command via Bluetooth as HID key event
        GApp2App.sendHIDKeyTyped(modifiers: modifiers, keyCodes: [keyCode])
    }
        
    // event via BTChangeListener
    public func onManagerDataChange(_ central: CBCentralManager) {
        //not used
    }
    
    // event via BTChangeListener
    public func onPeripheralChange(_ central: CBCentralManager, _ peripheral: CBPeripheral) {
        //not used
    }
    
    // event via BTChangeListener
    // incomming data from BLE - Incoming gesture
    public func onPeripheralDataChange(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ characteristic: CBCharacteristic) {
        Globals.log("GestureDispatcher:onPeripheralDataChange called...")
        let value = characteristic.value ?? Data()
        let message = String(data: value, encoding: .utf8)
        
        let gobj: GestureJson? = BT.decodeDataToObject(data: value)
        
        Globals.log("GestureDispatcher: BT Received message: \(gobj.debugDescription)")
        let gkey = gobj?.gestureKey ?? ""
        let command = gobj?.gestureCommand ?? ""
        
        let gm:InGestureMapping? = inGesturesStore?.getGestureMapping(gkey) ?? nil
        if (gm != nil ) {
            if(gm?.getIGActionType() == GInActionType.ExecuteCommand){
                Globals.log("GestureDispatcher:Executing InGesture command ...")
                //CommandExecutor.executeCommand(gesture?.getCommand())
                
            } else  if(gm?.getIGActionType() == GInActionType.ExecuteCmdAndSendToWatch){
                Globals.log("GestureDispatcher:Executing gesture command and fwd to Watch...")
                //TODO ...execute command
                //send to bluetooth
                //sendViaBluetooth(gkey, 0.0, command)
                
            } else  if(gm?.getIGActionType() == GInActionType.ForwardToWatch){
                Globals.log("GestureDispatcher:Forwarding gesture to watch...")
                
                //send to paired watch
                let msg = gm!.getIWatchHaptic()?.rawValue ?? HapticType.none.rawValue + Device.Watch_Phone_Topic_HMSG_Separator + gm!.getIWatchMessage()
                GApp2App.sendWatchAMessage(Device.Watch_Phone_Topic_HMSG_Key, msg)
            }
        }
    }
    
    
}

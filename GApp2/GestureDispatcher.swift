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
       

    
    public func gestureEvaluationCompleted(_ gw: GestureWindow, _ status: GestureEvaluationStatus) {
        let gkey = status.getGestureKey()
        let gCorr:Double = status.getGestureCorrelationFactor()
        
        let gesture:Gesture4D? = gesturesStore?.getGesture(gkey) ?? nil
        if (gesture != nil && gCorr >= (gesture?.getActionThreshold())!) {
            if(gesture?.getActionType() == ActionType.executeCommand){
                Globals.log("GestureDispatcher:Executing gesture command ...")
                //CommandExecutor.executeCommand(gesture?.getCommand())
                
            } else  if(gesture?.getActionType() == ActionType.executeCmdViaBluetooth){
                Globals.log("GestureDispatcher:Executing gesture command ...")
                
                //send to bluetooth
                sendViaBluetooth(gCorr, gesture!)
            }
        }
    }
    
    //
    fileprivate func sendViaBluetooth(_ gCorr: Double, _ gesture: Gesture4D) {
        
        Globals.log("GestureDispatcher:Forwarding gesture viw BT...")
        let gCorrFt = String(format: self.correlationFactorFormat, gCorr)
        let cutCorrFt:Double = floor(gCorr * 1000.0)/1000.0
        let gs:GestureJson = GestureJson(gesture.getName(), cutCorrFt, gesture.getCommand() )
        
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
        
    public func onManagerDataChange(_ central: CBCentralManager) {
        Globals.log("GestureDispatcher:onManagerDataChange called...")
        //not used
    }
    
    public func onPeripheralChange(_ central: CBCentralManager, _ peripheral: CBPeripheral) {
        Globals.log("GestureDispatcher:onPeripheralChange called...")
        //not used
    }
    
    public func onPeripheralDataChange(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ characteristic: CBCharacteristic) {
        Globals.log("GestureDispatcher:onPeripheralDataChange called...")
        let value = characteristic.value ?? Data()
        let message = String(data: value, encoding: .utf8)
        Globals.log("BT Received message: \(message)")
    }
    
    
}

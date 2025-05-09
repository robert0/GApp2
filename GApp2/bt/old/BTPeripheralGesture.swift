//
//  BTPeripheralGesture.swift
//  GApp
//
//  Created by Robert Talianu
//
import CoreBluetooth
import OrderedCollections
import UIKit

class BTPeripheralGesture: GestureEvaluationListener {
    var btpObj: BTPeripheralObj_OUT?
    private var mDataChangeListener: BTChangeListener?
    private let correlationFactorFormat: String = " %.3f"//add space first for good JSON formatting
    
    init() {
        btpObj = BTPeripheralObj_OUT()
        Globals.log("Starting CBCentralManager...")
    }
    
    /**
     * @param dataChangeListener
     */
    public func setChangeListener(_ dataChangeListener: BTChangeListener) {
        mDataChangeListener = dataChangeListener
    }
     
    /**
     *
     */
    public func gestureEvaluationCompleted(_ gw: GestureWindow, _ status: GestureEvaluationStatus) {
        Globals.log("BTPeripheralGesture gestureEvaluationCompleted...")
        //trigger repaint
        //onDataChange()
        
        guard let peripheralMgr = btpObj?.peripheralManager,
              let characteristic = btpObj?.advertiseCharacteristic
        else {
            Globals.log("BT message not send. PeripheralMgr or Characteristic not initialized")
            return
        }
        let gkey = status.getGestureKey();
        let gCorr = status.getGestureCorrelationFactor();
        let gCorrFt = String(format: self.correlationFactorFormat, gCorr)
        let jsonDataStr = "{\"gestureKey\":\"\(gkey)\", \"gestureCorrelationFactor\":\(gCorrFt)}"
        let jsonData = jsonDataStr.data(using: .utf8) ?? Data()
        
        
        //Globals.log("BT Sending position: \(jsonDataStr)")
        peripheralMgr.updateValue(jsonData, for: characteristic, onSubscribedCentrals:nil)
    }
}

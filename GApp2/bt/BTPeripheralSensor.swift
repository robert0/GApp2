//
//  BTPeripheralSensor.swift
//  GApp
//
//  Created by Robert Talianu
//
import CoreBluetooth
import OrderedCollections
import UIKit

class BTPeripheralSensor: SensorListener {
    var btpObj: BTPeripheralObj?
    private var mDataChangeListener: BTChangeListener?
    
    init() {
        btpObj = BTPeripheralObj()
        Globals.logToScreen("Starting CBCentralManager...")
    }
    
    /**
     * @param dataChangeListener
     */
    public func setChangeListener(_ dataChangeListener: BTChangeListener) {
        mDataChangeListener = dataChangeListener
    }
     
    /**
     * @param dataChangeListener
     */
    func onSensorChanged(_ time: Int64, _ x: Double, _ y: Double, _ z: Double) {
        guard let peripheralMgr = btpObj?.peripheralManager,
              let characteristic = btpObj?.characteristic
        else {
            Globals.logToScreen("BT message not send. PeripheralMgr or Characteristic not initialized")
            return
        }
        
        let p4d  = Sample4D(x, y, z, time)
        let jsonDataStr = p4d.toJSON(6)
        let jsonData = jsonDataStr.data(using: .utf8) ?? Data()
        
        //Globals.logToScreen("BT Sending position: \(jsonDataStr)")
        peripheralMgr.updateValue(jsonData, for: characteristic, onSubscribedCentrals:nil)
    }
}

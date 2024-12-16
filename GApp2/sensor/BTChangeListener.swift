//
//  DataChangeListener.swift
//  GApp
//
//  Created by Robert Talianu
//

import CoreBluetooth


public protocol BTChangeListener {
    
    /**
     * @return
     */
    func onManagerDataChange(_ central: CBCentralManager);
    
    /**
     * @return
     */
    func onPeripheralChange(_ central: CBCentralManager, _ peripheral: CBPeripheral);
    
    /**
     * @return
     */
    func onPeripheralDataChange();
}

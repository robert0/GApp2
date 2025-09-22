//
//  HIDPeripheralSubscriptionManager.swift
//  GApp2
//
//  Created by Robert Talianu
//


import CoreBluetooth
import Combine

class HIDPeripheralSubscriptionManager: ObservableObject {
    static let shared = HIDPeripheralSubscriptionManager()
    
    @Published var hidSubscribers: [CBCentral] = []
    
    func central(_ central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        objectWillChange.send()
        ToastManager.show("Bluetooth HID Subscriber added", .success)
        if characteristic.uuid == BT.hidReportUUID {
            if !hidSubscribers.contains(where: { $0.identifier == central.identifier }) {
                hidSubscribers.append(central)
            }
        }
    }
    
    func central(_ central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        objectWillChange.send()
        ToastManager.show("Bluetooth HID Subscriber removed", .success)
        if characteristic.uuid == BT.hidReportUUID {
            hidSubscribers.removeAll { $0.identifier == central.identifier }
        }
    }
    

    func getHidSubscribersCount() -> Int {
        return hidSubscribers.count
    }
        
}

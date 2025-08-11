//
//  BLEHIDKeyboard.swift
//  ios_hid2
//
//  Created by Dan Durbaca on 02.08.2025.
//

import CoreBluetooth

class BLEHIDKeyboard: NSObject, CBPeripheralManagerDelegate {
    
    private var peripheralManager: CBPeripheralManager!
    
    //let hidServiceUUID = CBUUID(string: "1812")
    let hidServiceUUID = CBUUID(string: "00001812-0000-1000-8000-00805F9B34FB")
    let reportMapUUID = CBUUID(string: "2A4B")
    let reportUUID = CBUUID(string: "2A4D")
    let protocolModeUUID = CBUUID(string: "2A4E")
    let hidInformationUUID = CBUUID(string: "2A4A")
    let hidControlPointUUID = CBUUID(string: "2A4C")
    let reportReferenceUUID = CBUUID(string: "2908")
    
    var protocolModeValue = Data([0x01])  // Report Protocol Mode (default)
    
    var reportCharacteristic: CBMutableCharacteristic!
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Advertising
    
    func startAdvertising() {
        let advertisementData: [String: Any] = [
            CBAdvertisementDataServiceUUIDsKey: [hidServiceUUID],
            CBAdvertisementDataLocalNameKey: "SwiftBLEKeyboard"
        ]
        peripheralManager.startAdvertising(advertisementData)
        print("HIDKeyboard: Started Advertising")
    }
    
    func stopAdvertising() {
        peripheralManager.stopAdvertising()
        print("HIDKeyboard: Stopped Advertising")
    }
    
    // MARK: - Setup HID Service
    
    private func setupHIDService() {
        
        let hidInfoData = Data([0x11, 0x01, 0x00, 0x03])
        
        let hidInformationCharacteristic = CBMutableCharacteristic(
            type: hidInformationUUID,
            properties: [.read],
            value: hidInfoData,
            permissions: [.readable]
        )
        
        let protocolModeCharacteristic = CBMutableCharacteristic(
            type: protocolModeUUID,
            properties: [.read, .writeWithoutResponse],
            value: nil,
            permissions: [.readable, .writeable]
        )
        
        let hidControlPointCharacteristic = CBMutableCharacteristic(
            type: hidControlPointUUID,
            properties: [.writeWithoutResponse],
            value: nil,
            permissions: [.writeable]
        )
        
        let reportMapCharacteristic = CBMutableCharacteristic(
            type: reportMapUUID,
            properties: [.read],
            value: hidReportMap,
            permissions: [.readable]
        )
        
        let reportReferenceDescriptor = CBMutableDescriptor(
            type: reportReferenceUUID,
            value: Data([0x01, 0x01]) // Report ID 1, Input Report
        )
        
        reportCharacteristic = CBMutableCharacteristic(
            type: reportUUID,
            properties: [.read, .notify],
            value: nil,
            permissions: [.readable]
        )
        reportCharacteristic.descriptors = [reportReferenceDescriptor]
        
        let hidService = CBMutableService(type: hidServiceUUID, primary: true)
        hidService.characteristics = [
            hidInformationCharacteristic,
            protocolModeCharacteristic,
            hidControlPointCharacteristic,
            reportMapCharacteristic,
            reportCharacteristic
        ]
        
        peripheralManager.removeAllServices()
        peripheralManager.add(hidService)
    }
    
    private let hidReportMap: Data = {
        return Data([
            0x05, 0x01, 0x09, 0x06, 0xA1, 0x01,
            0x05, 0x07, 0x19, 0xE0, 0x29, 0xE7,
            0x15, 0x00, 0x25, 0x01, 0x75, 0x01,
            0x95, 0x08, 0x81, 0x02, 0x95, 0x01,
            0x75, 0x08, 0x81, 0x03, 0x95, 0x05,
            0x75, 0x01, 0x05, 0x08, 0x19, 0x01,
            0x29, 0x05, 0x91, 0x02, 0x95, 0x01,
            0x75, 0x03, 0x91, 0x03, 0x95, 0x06,
            0x75, 0x08, 0x15, 0x00, 0x25, 0x65,
            0x05, 0x07, 0x19, 0x00, 0x29, 0x65,
            0x81, 0x00, 0xC0
        ])
    }()
    
    // MARK: - CBPeripheralManagerDelegate
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("HIDKeyboard: Bluetooth powered on, setting up HID service...")
            setupHIDService()
        default:
            print("HIDKeyboard: Bluetooth not powered on: \(peripheral.state.rawValue)")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("Error adding service: \(error.localizedDescription)")
            return
        }
        print("HIDKeyboard: Service added successfully, starting advertising...")
        startAdvertising()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        switch request.characteristic.uuid {
        case protocolModeUUID:
            request.value = protocolModeValue
            peripheral.respond(to: request, withResult: .success)
        case hidInformationUUID, reportMapUUID, reportUUID:
            // Characteristics with cached values or notify
            peripheral.respond(to: request, withResult: .success)
        default:
            peripheral.respond(to: request, withResult: .requestNotSupported)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            switch request.characteristic.uuid {
            case protocolModeUUID:
                if let newValue = request.value {
                    protocolModeValue = newValue
                    print("HIDKeyboard: Protocol Mode updated: \(newValue as NSData)")
                }
                peripheral.respond(to: request, withResult: .success)
            case hidControlPointUUID:
                print("HIDKeyboard: HID Control Point write received")
                peripheral.respond(to: request, withResult: .success)
            default:
                peripheral.respond(to: request, withResult: .requestNotSupported)
            }
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("HIDKeyboard: Central subscribed to characteristic: \(characteristic.uuid)")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("HIDKeyboard: Central unsubscribed from characteristic: \(characteristic.uuid)")
    }
    
    // MARK: - Sending key reports
    
    func sendKeyPress(keyCode: UInt8) {
        var report = Data([0x00, 0x00, keyCode, 0x00, 0x00, 0x00, 0x00, 0x00])
        let success = peripheralManager.updateValue(report, for: reportCharacteristic, onSubscribedCentrals: nil)
        print("HIDKeyboard: Sent key press \(keyCode), success: \(success)")
    }
    
    func sendKeyRelease() {
        let report = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
        let success = peripheralManager.updateValue(report, for: reportCharacteristic, onSubscribedCentrals: nil)
        print("HIDKeyboard: Sent key release, success: \(success)")
    }
}

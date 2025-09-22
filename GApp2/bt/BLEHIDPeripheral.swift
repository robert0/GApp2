//
//  BLEHIDPeripheral.swift
//
//  Created by Dan Durbaca on 03.08.2025.
//

import CoreBluetooth
import UIKit

class BLEHIDPeripheral: NSObject {
    private var peripheralManager: CBPeripheralManager!
    private var hidService: CBMutableService!
    
    //public values
    public var mouseInputReportCharacteristic: CBMutableCharacteristic!
    public var keyboardInputReportCharacteristic: CBMutableCharacteristic!
    //
    private var reportMapCharacteristic: CBMutableCharacteristic!
    private var protocolModeCharacteristic: CBMutableCharacteristic!
    private var hidInfoCharacteristic: CBMutableCharacteristic!
    private var hidControlPointCharacteristic: CBMutableCharacteristic!
    private var outputReportCharacteristic: CBMutableCharacteristic!
    
    let reportMap = Data([
        // Mouse (Report ID 1)
        0x05, 0x01,       // Usage Page (Generic Desktop)
        0x09, 0x02,       // Usage (Mouse)
        0xA1, 0x01,       // Collection (Application)
        0x85, 0x01,       //   Report ID (1)
        0x09, 0x01,       //   Usage (Pointer)
        0xA1, 0x00,       //   Collection (Physical)
        0x05, 0x09,       //     Usage Page (Buttons)
        0x19, 0x01,       //     Usage Minimum (1)
        0x29, 0x03,       //     Usage Maximum (3)
        0x15, 0x00,       //     Logical Minimum (0)
        0x25, 0x01,       //     Logical Maximum (1)
        0x95, 0x03,       //     Report Count (3)
        0x75, 0x01,       //     Report Size (1)
        0x81, 0x02,       //     Input (Data, Variable, Absolute)
        0x95, 0x01,       //     Report Count (1)
        0x75, 0x05,       //     Report Size (5)
        0x81, 0x03,       //     Input (Constant, Variable, Absolute)
        0x05, 0x01,       //     Usage Page (Generic Desktop)
        0x09, 0x30,       //     Usage (X)
        0x09, 0x31,       //     Usage (Y)
        0x15, 0x81,       //     Logical Minimum (-127)
        0x25, 0x7F,       //     Logical Maximum (127)
        0x75, 0x08,       //     Report Size (8)
        0x95, 0x02,       //     Report Count (2)
        0x81, 0x06,       //     Input (Data, Variable, Relative)
        0xC0,             //   End Collection
        0xC0,             // End Collection
        
        // Keyboard (Report ID 2)A
        0x05, 0x01,        // Usage Page (Generic Desktop)
        0x09, 0x06,        // Usage (Keyboard)
        0xA1, 0x01,        // Collection (Application)
        0x85, 0x02,       //   Report ID (2)
        0x05, 0x07,        // Usage Page (Key Codes)
        0x19, 0xE0,        // Usage Minimum (224)
        0x29, 0xE7,        // Usage Maximum (231)
        0x15, 0x00,        // Logical Minimum (0)
        0x25, 0x01,        // Logical Maximum (1)
        0x75, 0x01,        // Report Size (1)
        0x95, 0x08,        // Report Count (8)
        0x81, 0x02,        // Input (Data, Variable, Absolute) ; Modifier byte
        0x95, 0x01,        // Report Count (1)
        0x75, 0x08,        // Report Size (8)
        0x81, 0x01,        // Input (Constant) ; Reserved byte
        0x95, 0x05,        // Report Count (5)
        0x75, 0x01,        // Report Size (1)
        0x05, 0x08,        // Usage Page (LEDs)
        0x19, 0x01,        // Usage Minimum (1)
        0x29, 0x05,        // Usage Maximum (5)
        0x91, 0x02,        // Output (Data, Variable, Absolute) ; LED report
        0x95, 0x01,        // Report Count (1)
        0x75, 0x03,        // Report Size (3)
        0x91, 0x01,        // Output (Constant) ; Padding
        0x95, 0x06,        // Report Count (6)
        0x75, 0x08,        // Report Size (8)
        0x15, 0x00,        // Logical Minimum (0)
        0x25, 0x65,        // Logical Maximum (101)
        0x05, 0x07,        // Usage Page (Key Codes)
        0x19, 0x00,        // Usage Minimum (0)
        0x29, 0x65,        // Usage Maximum (101)
        0x81, 0x00,        // Input (Data, Array) ; Key arrays (6 bytes)
        0xC0               // End Collection
    ])
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    private func setupHIDService() {
        let hidServiceUUID = CBUUID(string: "00001812-0000-1000-8000-00805F9B34FB")
        
        // Report Map
        let reportMapUUID = CBUUID(string: "2A4B")
        reportMapCharacteristic = CBMutableCharacteristic(
            type: reportMapUUID,
            properties: [.read],
            value: reportMap,
            permissions: [.readable]
        )
        let reportMapReferenceDescriptor = CBMutableDescriptor(
            type: CBUUID(string: "2908"),
            value: Data([0x00, 0x00]) // Report ID = 0 (Report Map), Type = 0 (Unknown)
        )
        reportMapCharacteristic.descriptors = [reportMapReferenceDescriptor]
        
        // Protocol Mode
        let protocolModeUUID = CBUUID(string: "2A4E")
        protocolModeCharacteristic = CBMutableCharacteristic(
            type: protocolModeUUID,
            properties: [.read, .writeWithoutResponse],
            value: nil,
            permissions: [.readable, .writeable]
        )
        
        // HID Information
        let hidInfoUUID = CBUUID(string: "2A4A")
        hidInfoCharacteristic = CBMutableCharacteristic(
            type: hidInfoUUID,
            properties: [.read],
            value: Data([0x11, 0x01, 0x00, 0x03]),
            permissions: [.readable]
        )
        
        let hidControlPointUUID = CBUUID(string: "2A4C")
        hidControlPointCharacteristic = CBMutableCharacteristic(
            type: hidControlPointUUID,
            properties: [.writeWithoutResponse],
            value: nil,
            permissions: [.writeable]
        )
        
        // Input Report
        //let inputReportUUID = CBUUID(string: "2A4D")
        mouseInputReportCharacteristic = CBMutableCharacteristic(
            type: BT.hidReportUUID,
            properties: [.read, .notify],
            value: nil,
            permissions: [.readable]
        )
        
        // Only add the Report Reference Descriptor (0x2908): Report ID = 1, Type = Input (1)
        let reportReferenceDescriptor = CBMutableDescriptor(
            type: CBUUID(string: "2908"),
            value: Data([0x01, 0x01])
        )
        
        mouseInputReportCharacteristic.descriptors = [reportReferenceDescriptor]
        
        // Keyboard Input Report
        //let keyboardInputReportUUID = CBUUID(string: "2A4D")
        keyboardInputReportCharacteristic = CBMutableCharacteristic(
            type: BT.hidReportUUID,
            properties: [.read, .notify],
            value: nil,
            permissions: [.readable]
        )
        let keyboardReportReferenceDescriptor = CBMutableDescriptor(
            type: CBUUID(string: "2908"),
            value: Data([0x02, 0x01]) // Report ID = 2, Type = Input
        )
        keyboardInputReportCharacteristic.descriptors = [keyboardReportReferenceDescriptor]
        
        outputReportCharacteristic = CBMutableCharacteristic(
            type: CBUUID(string: "2A4E"), // Sau 2A4D
            properties: [.read, .write, .writeWithoutResponse],
            value: nil,
            permissions: [.readable, .writeable]
        )
        
        let outputReportDescriptor = CBMutableDescriptor(
            type: CBUUID(string: "2908"),
            value: Data([0x02, 0x02]) // Report ID = 2, Type = OutputAAAAAA
        )
        
        outputReportCharacteristic.descriptors = [outputReportDescriptor]
        
        // Assemble HID service
        hidService = CBMutableService(type: hidServiceUUID, primary: true)
        hidService.characteristics = [
            reportMapCharacteristic,
            protocolModeCharacteristic,
            hidInfoCharacteristic,
            mouseInputReportCharacteristic,
            keyboardInputReportCharacteristic,
            hidControlPointCharacteristic,
            outputReportCharacteristic
        ]
        
        peripheralManager.add(hidService)
    }
    
    private func startAdvertising() {
        let advertisementData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: "BLE Mouse",
            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "00001812-0000-1000-8000-00805F9B34FB")],
            "kCBAdvDataAppearance": 0x03C2  // Appearance: Generic Mouse
        ]
        
        peripheralManager.startAdvertising(advertisementData)
    }
    
    public func sendMouseMove(dx: Int8, dy: Int8, buttons: UInt8 = 0) {
        let report: [UInt8] = [buttons, UInt8(bitPattern: dx), UInt8(bitPattern: dy)]
        let reportData = Data(report)
        peripheralManager.updateValue(reportData, for: mouseInputReportCharacteristic, onSubscribedCentrals: nil)
        
        if buttons != 0 {
            // Send "button release" after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                let releaseReport: [UInt8] = [0x00, 0x00, 0x00]
                let releaseData = Data(releaseReport)
                self.peripheralManager.updateValue(releaseData, for: self.mouseInputReportCharacteristic, onSubscribedCentrals: nil)
            }
        }
    }
    
    public func sendKeyboardInput(unicode: Character) {
        // Simple ASCII mapping example (expand for full Unicode support)
        let asciiValue = unicode.asciiValue ?? 0
        var keyCode: UInt8 = 0
        var modifier: UInt8 = 0

        // Example: map 'A'-'Z' and 'a'-'z'
        if asciiValue >= 65 && asciiValue <= 90 { // 'A'-'Z'
            keyCode = asciiValue - 65 + 0x04
            modifier = 0x02 // Shift
        } else if asciiValue >= 97 && asciiValue <= 122 { // 'a'-'z'
            keyCode = asciiValue - 97 + 0x04
        }
        // Add more mappings for digits, symbols, etc.

        sendKeyboardInput(modifiers: modifier, keyCodes: [keyCode])
    }
    
    public func sendKeyboardInput(modifiers: UInt8, keyCodes: [UInt8]) {
        // 1. Key press report
        var pressReport: [UInt8] = []
        pressReport.append(modifiers)     // Modifier byte (e.g. 0x02 = Shift)
        pressReport.append(0x00)          // Reserved byte
        let padded = keyCodes + Array(repeating: 0x00, count: max(0, 6 - keyCodes.count))
        pressReport.append(contentsOf: padded.prefix(6))
        
        let pressData = Data(pressReport)
        peripheralManager.updateValue(pressData, for: keyboardInputReportCharacteristic, onSubscribedCentrals: nil)
        print("BLEHIDPeripheral: 🔵 Sent key press: \(pressData as NSData)")
        
        // 2. Key release report (modifier + keycodes all 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            let releaseReport: [UInt8] = [0x00, 0x00] + Array(repeating: 0x00, count: 6)
            let releaseData = Data(releaseReport)
            self.peripheralManager.updateValue(releaseData, for: self.keyboardInputReportCharacteristic, onSubscribedCentrals: nil)
            print("BLEHIDPeripheral: ⚪️ Sent key release: \(releaseData as NSData)")
        }
    }
}

// MARK: - CBPeripheralManagerDelegate
extension BLEHIDPeripheral: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("BLEHIDPeripheral: Peripheral state changed: \(peripheral.state.rawValue)")
        if peripheral.state == .poweredOn {
            setupHIDService()
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("BLEHIDPeripheral: Failed to add service: \(error.localizedDescription)")
        } else {
            print("BLEHIDPeripheral: Service added, starting advertisement")
            startAdvertising()
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("BLEHIDPeripheral: Central subscribed to characteristic p:\(peripheral.description), c:\(central.debugDescription), ch:\(characteristic.uuid.uuidString)")
        HIDPeripheralSubscriptionManager.shared.central( central, didSubscribeTo:  characteristic)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("BLEHIDPeripheral: Central didUnsubscribeFrom from characteristic p:\(peripheral.debugDescription), c:\(central.debugDescription), ch:\(characteristic.uuid.uuidString)")
        HIDPeripheralSubscriptionManager.shared.central( central, didUnsubscribeFrom:  characteristic)
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("BLEHIDPeripheral: didReceiveWrite...")
        for request in requests {
            if request.characteristic.uuid == protocolModeCharacteristic.uuid {
                print("BLEHIDPeripheral: Protocol mode write: \(request.value?.first ?? 0)")
                peripheral.respond(to: request, withResult: .success)
            } else {
                peripheral.respond(to: request, withResult: .requestNotSupported)
            }
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("BLEHIDPeripheral: didReceiveRead...")
        if request.characteristic.uuid == reportMapCharacteristic.uuid {
            if request.offset > reportMap.count {
                peripheral.respond(to: request, withResult: .invalidOffset)
                return
            }
            request.value = reportMap.subdata(in: request.offset..<reportMap.count)
            peripheral.respond(to: request, withResult: .success)
        } else {
            peripheral.respond(to: request, withResult: .requestNotSupported)
        }
    }
}

// MARK: - CBPeripheralDelegate
extension BLEHIDPeripheral: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("BLEHIDPeripheral: Service: \(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print("BLEHIDPeripheral: Characteristic: \(characteristic.uuid), Properties: \(characteristic.properties)")
        }
    }
}

//
//  BLEMousePeripheral.swift
//  ios_hid2
//
//  Created by Dan Durbaca on 03.08.2025.
//

import CoreBluetooth
import UIKit

class BLEMousePeripheral: NSObject {
    private var peripheralManager: CBPeripheralManager!
    private var hidService: CBMutableService!

    private var reportMapCharacteristic: CBMutableCharacteristic!
    private var inputReportCharacteristic: CBMutableCharacteristic!
    private var protocolModeCharacteristic: CBMutableCharacteristic!
    private var hidInfoCharacteristic: CBMutableCharacteristic!

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    private func setupHIDService() {
        let hidServiceUUID = CBUUID(string: "00001812-0000-1000-8000-00805F9B34FB")

        // Report Map
        let reportMapUUID = CBUUID(string: "2A4B")
        let reportMap = Data([
            0x05, 0x01,       // Usage Page (Generic Desktop)
            0x09, 0x02,       // Usage (Mouse)
            0xA1, 0x01,       // Collection (Application)
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
            0x81, 0x03,       //     Input (Constant) ; padding
            0x05, 0x01,       //     Usage Page (Generic Desktop)
            0x09, 0x30,       //     Usage (X)
            0x09, 0x31,       //     Usage (Y)
            0x15, 0x81,       //     Logical Minimum (-127)
            0x25, 0x7F,       //     Logical Maximum (127)
            0x75, 0x08,       //     Report Size (8)
            0x95, 0x02,       //     Report Count (2)
            0x81, 0x06,       //     Input (Data, Variable, Relative)
            0xC0,             //   End Collection
            0xC0              // End Collection
        ])
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

        // Input Report
        let inputReportUUID = CBUUID(string: "2A4D")
        inputReportCharacteristic = CBMutableCharacteristic(
            type: inputReportUUID,
            properties: [.read, .notify],
            value: nil,
            permissions: [.readable]
        )

        // Only add the Report Reference Descriptor (0x2908): Report ID = 1, Type = Input (1)
        let reportReferenceDescriptor = CBMutableDescriptor(
            type: CBUUID(string: "2908"),
            value: Data([0x01, 0x01])
        )

        inputReportCharacteristic.descriptors = [reportReferenceDescriptor]

        // Assemble HID service
        hidService = CBMutableService(type: hidServiceUUID, primary: true)
        hidService.characteristics = [
            reportMapCharacteristic,
            protocolModeCharacteristic,
            hidInfoCharacteristic,
            inputReportCharacteristic
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
        print("HIDMouse: Advertising started...")
    }

    func sendMouseMove(_ dx: Int8, _ dy: Int8, _ buttons: UInt8 = 0) {
        let report: [UInt8] = [buttons, UInt8(bitPattern: dx), UInt8(bitPattern: dy)]
        let reportData = Data(report)
        peripheralManager.updateValue(reportData, for: inputReportCharacteristic, onSubscribedCentrals: nil)
        print("HIDMouse: Mouse move sent with dx: \(dx), dy: \(dy), buttons: \(buttons)")
    }
}

// ########
// Extension for main class to conform to CBPeripheralManagerDelegate
// ########
extension BLEMousePeripheral: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("HIDMouse: Peripheral state changed: \(peripheral.state.rawValue)")
        if peripheral.state == .poweredOn {
            setupHIDService()
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("HIDMouse: Failed to add service: \(error.localizedDescription)")
        } else {
            print("HIDMouse: Service added, starting advertisement")
            startAdvertising()
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("HIDMouse: Central subscribed to input report")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if request.characteristic.uuid == protocolModeCharacteristic.uuid {
                print("HIDMouse: Protocol mode write: \(request.value?.first ?? 0)")
                peripheral.respond(to: request, withResult: .success)
            } else {
                peripheral.respond(to: request, withResult: .requestNotSupported)
            }
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        if request.characteristic.uuid == reportMapCharacteristic.uuid {
            let reportMap = Data([
                0x05, 0x01, 0x09, 0x02, 0xA1, 0x01, 0x09, 0x01, 0xA1, 0x00,
                0x05, 0x09, 0x19, 0x01, 0x29, 0x03, 0x15, 0x00, 0x25, 0x01,
                0x95, 0x03, 0x75, 0x01, 0x81, 0x02, 0x95, 0x01, 0x75, 0x05,
                0x81, 0x03, 0x05, 0x01, 0x09, 0x30, 0x09, 0x31, 0x15, 0x81,
                0x25, 0x7F, 0x75, 0x08, 0x95, 0x02, 0x81, 0x06, 0xC0, 0xC0
            ])
            if request.offset > reportMap.count {
                peripheral.respond(to: request, withResult: .invalidOffset)
                return
            }
            request.value = reportMap.subdata(in: Int(request.offset)..<reportMap.count)
            peripheral.respond(to: request, withResult: .success)
        } else {
            peripheral.respond(to: request, withResult: .requestNotSupported)
        }
    }
}

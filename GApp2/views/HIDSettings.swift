//
//  Settings.swift
//  GApp2
//
//  Created by Robert Talianu
//

import CoreMotion
import Foundation
import SwiftUI
import CoreBluetooth

class HIDBluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    @Published var peripherals: [CBPeripheral] = []
    @Published var connectedPeripheral: CBPeripheral?
    @Published  var central: CBCentralManager!
    @Published var hidp: BLEHIDPeripheral?
    
    override init() {
        super.init()
        hidp = GApp2App.activateHIDInterface()//ensure this is created
        central = CBCentralManager(delegate: self, queue: nil)
    }
    
    /// Called when the state of the central manager is updated.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth is ON. Scanning...")
            central.scanForPeripherals(withServices: nil)
        } else {
            print("Bluetooth not available")
        }
    }
    
    /// Handles the discovery of new peripherals.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            peripherals.append(peripheral)
        }
    }
    
    /// Connects to the specified peripheral.
    func connect(_ peripheral: CBPeripheral) {
        print("Connecting to: \(peripheral.name ?? "Unnamed") ...")
        peripheral.delegate = hidp
        central.connect(peripheral, options: nil)
    }
    
    /// Disconnects the specified peripheral.
    func disconnect(_ peripheral: CBPeripheral) {
        print("Disconnecting from: \(peripheral.name ?? "Unnamed") ...")
        central.cancelPeripheralConnection(peripheral)
        if connectedPeripheral?.identifier == peripheral.identifier {
            connectedPeripheral = nil
        }
    }
    
    /// Disconnects the currently connected peripheral.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to: \(peripheral.name ?? "Unnamed")")
        connectedPeripheral = peripheral
        peripheral.delegate = hidp
        peripheral.discoverServices(nil)
    }
    
    /// Handles disconnection from a peripheral.
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from: \(peripheral.name ?? "Unnamed")")
        if connectedPeripheral?.identifier == peripheral.identifier {
            connectedPeripheral?.delegate = nil
            connectedPeripheral = nil
        }
    }
}

struct HIDSettings: View {
    @StateObject private var btManager = HIDBluetoothManager()
    @State private var showOnlyNamed = false

    var filteredPeripherals: [CBPeripheral] {
        showOnlyNamed
            ? btManager.peripherals.filter { ($0.name?.isEmpty == false) }
            : btManager.peripherals
    }

    var body: some View {
        VStack {
            Toggle("Show only named peripherals", isOn: $showOnlyNamed)
                .padding()
            List {
                ForEach(filteredPeripherals, id: \.identifier) { peripheral in
                    HStack {
                        Text(peripheral.name ?? "Unknown")
                        Spacer()
                        if btManager.connectedPeripheral?.identifier == peripheral.identifier {
                            Button("Disconnect") {
                                btManager.disconnect(peripheral)
                            }
                        } else {
                            Button("Connect") {
                                btManager.connect(peripheral)
                            }
                        }
                    }
                    .padding()
                    .background(
                        btManager.connectedPeripheral?.identifier == peripheral.identifier
                        ? Color.green.opacity(0.3)
                        : Color.clear
                    )
                    .cornerRadius(8)
                }
            }
            .navigationTitle("Nearby Bluetooth Devices")
        }
    }
}

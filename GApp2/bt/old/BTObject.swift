//
//  BTObject.swift
//  GApp
//
//  Created by Robert Talianu
//
import CoreBluetooth
import OrderedCollections
import UIKit

class BTObject: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    private let SERVICE_UUID = CBUUID(string: "8c2a81f7-f8b8-4b31-89b4-6b5d98a822db")
    private let CHARACTERISTIC_UUID = CBUUID(string: "e8bd8c82-2506-4fae-b5f2-9bbbf4ab5b0e")
    
    private var peripheralsMap = OrderedDictionary<String, CBPeripheral>()
    private var btChangeListener: BTChangeListener?

    override init() {
        super.init()
        Globals.log("Starting CBCentralManager...")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    /**
     * @param dataChangeListener
     */
    public func setChangeListener(_ dataChangeListener: BTChangeListener) {
        btChangeListener = dataChangeListener
    }

    /**
     *
     */
    func getPeripheralMap() -> OrderedDictionary<String, CBPeripheral> {
        return peripheralsMap
    }

    // Called when BT changes state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Globals.log("Central state update:" + String(central.state.rawValue))

        btChangeListener?.onManagerDataChange(central)

                switch central.state {
                case CBManagerState.poweredOn:
                    // Notify user Bluetooth in ON
                    // auto-initialize the scanning
                    startScan()
                    fallthrough
                case CBManagerState.poweredOff:
                    // Alert user to turn on Bluetooth
                    fallthrough
                case CBManagerState.resetting:
                    // Wait for next state update and consider logging interruption of Bluetooth service
                    fallthrough
                case CBManagerState.unauthorized:
                    // Alert user to enable Bluetooth permission in app Settings
                    fallthrough
                case CBManagerState.unsupported:
                    // Alert user their device does not support Bluetooth and app will not work as expected
                    fallthrough
                case CBManagerState.unknown:
                    // Wait for next state update
                    fallthrough
                default:
                    return
                    //Globals.log("Central state update:" + String(central.state.rawValue))
                }
    }

   
    // Start Scanning
    //
    // @see self-called function
    //
    public func startScan() {
        Globals.log("BTO(\(centralManager.state.rawValue)|\(centralManager.isScanning)): Start Scanning called...")
        if(centralManager.state == CBManagerState.poweredOn && !centralManager.isScanning){
            peripheralsMap.removeAll()
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    // Stop Scanning
    public func stopScanning(){
        centralManager.stopScan()
    }
    
    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        Globals.log("Scan update ...")
        Globals.log("Found peripheral: " + (peripheral.name ?? "no-name, ") + peripheral.identifier.uuidString)

        //add peripheral to the map
        peripheralsMap[peripheral.identifier.uuidString] = peripheral

        btChangeListener?.onPeripheralChange(central, peripheral)
    }

    /**
     * Connect to the provided peripheral...
     * @see connecting to peripheral automatically stops the current scanning
     */
    public func connectToPeripheral(_ peripheral: CBPeripheral) {
        Globals.log("Connecting to peripheral: " + (peripheral.name ?? "unknown") + " " + peripheral.identifier.uuidString)
        
        //unlink previuos peripheral
        if(self.peripheral != nil){
            self.peripheral.delegate = nil
            self.centralManager.cancelPeripheralConnection(self.peripheral!)
        }
        
        //stop scanning first
        self.centralManager.stopScan()

        //link new peripheral
        self.peripheral = peripheral
        self.peripheral.delegate = self
        self.centralManager.connect(peripheral, options: nil)
    }

    // retry if error when connecting to peripheral
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Globals.log("Failed to connect, retrying...")
        centralManager.connect(peripheral, options: nil)
    }

    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Globals.log("Peripheral connected ...")
        if peripheral == self.peripheral {
            Globals.log("Discovering services...")
            peripheral.discoverServices(nil)
        }
    }

    // Handles services discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        Globals.log("Peripheral services discovery completed. " + (error?.localizedDescription ?? "(no-error)"))
        if let services = peripheral.services {
            for service in services {
                Globals.log("--s-- discovered service: \(service.uuid.uuidString) \(service.description)")
                //Now start discovery of characteristics
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        Globals.log("---- peripheral discovery characteristics...")
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                Globals.log("---- @ Peripheral characteristic found: \(characteristic.uuid.uuidString) \(characteristic.description)")
            }
        }
    }
    
    
    func sendText(_ text: String) {
        guard let peripheral = self.peripheral,
              let characteristic = peripheral.services?.first?.characteristics?.first(where: { $0.uuid == CHARACTERISTIC_UUID })
        else {
            Globals.log("Peripheral or characteristic not found")
            return
        }
        
        Globals.log("BT Sending: \(text)")
        let data = text.data(using: .utf8)!
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
}

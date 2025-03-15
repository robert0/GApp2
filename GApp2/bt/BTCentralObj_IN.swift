//
//  BTCentralObj.swift
//  GApp
//
//  Created by Robert Talianu
//
import CoreBluetooth
import OrderedCollections

//handles the discovery of peripherals, connection & data transfer from a remote peripheral/characteristic - via subscribe method
class BTCentralObj_IN: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    
    //var characteristic: CBMutableCharacteristic?
    private var remotePeripheral: CBPeripheral?
    private var remoteCharacteristic: CBCharacteristic?
    
    private var peripheralsMap = OrderedDictionary<String, CBPeripheral>()
    private var mDataChangeListeners: [BTChangeListener] = []
    
    override init() {
        super.init()
        Globals.logToScreen("BT Starting CBCentralManager...")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /**
     * @param dataChangeListener
     */
    public func addBTChangeListener(_ btChangeListener: BTChangeListener) {
        mDataChangeListeners.append(btChangeListener)
    }
    
   
    /**
     *
     */
    public func getPeripheralMap() -> OrderedDictionary<String, CBPeripheral> {
        return peripheralsMap
    }
    
    /**
     *
     */
    // Called when BT changes state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Globals.log("Central state update:" + String(central.state.rawValue))
        
        //notify
        mDataChangeListeners.forEach { $0.onManagerDataChange(central) }
        
        switch central.state {
        case CBManagerState.poweredOn:
            // Notify user Bluetooth in ON
            // auto-initialize the scanning
            // startScan()
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
    
    /**
     *
     */
    // Start Scanning
    public func startScan() {
        Globals.log("BTO(\(centralManager.state.rawValue)|\(centralManager.isScanning)): Start Scanning called...")
        if(centralManager.state == CBManagerState.poweredOn && !centralManager.isScanning){
            peripheralsMap.removeAll()
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    /**
     *
     */
    // Stop Scanning
    public func stopScanning(){
        centralManager.stopScan()
    }
    
    /**
     *
     */
    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        Globals.log("BT found peripheral: " + (peripheral.name ?? "no-name, ") + peripheral.identifier.uuidString)

        //add peripheral to the map
        peripheralsMap[peripheral.identifier.uuidString] = peripheral

        mDataChangeListeners.forEach { $0.onPeripheralChange(central, peripheral) }
    }
       
    
    /**
     * Connect to the provided peripheral...
     * @see connecting to peripheral automatically stops the current scanning
     */
    public func connectToPeripheral(_ peripheral: CBPeripheral) {
        Globals.log("BT Connecting to peripheral: " + (peripheral.name ?? "unknown") + " " + peripheral.identifier.uuidString)
        
        //unlink previuos peripheral
        if(remotePeripheral != nil){
            remotePeripheral!.delegate = nil
            centralManager.cancelPeripheralConnection(self.remotePeripheral!)
            if(remoteCharacteristic != nil){
                remotePeripheral!.setNotifyValue(false, for: remoteCharacteristic!)
            }
        }
        
        //stop scanning first
        centralManager.stopScan()

        //link new peripheral
        self.remotePeripheral = peripheral
        self.remotePeripheral!.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    // Retry if error when connecting to peripheral
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Globals.log("BT Failed to connect, retrying...")
        centralManager.connect(peripheral, options: nil)
    }

    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Globals.log("BT Peripheral connected ...")
        if peripheral == self.remotePeripheral {
            Globals.log("BT Discovering services...")
            peripheral.delegate = self
            peripheral.discoverServices(nil)
        }
    }

    //
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("BT Disconnected from peripheral")
    }

    
    // Handles services discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        Globals.log("BT Peripheral services discovery completed. " + (error?.localizedDescription ?? "(no-error)"))
        if let services = peripheral.services {
            for service in services {
                Globals.log("--s-- discovered service: \(service.uuid.uuidString) \(service.description)")
                //Now start discovery of characteristics
                if(service.uuid.uuidString == BT.ServiceUUID.uuidString) {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        Globals.log("--s-- peripheral discovery characteristics...")
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                Globals.log("--s--c--  @ Peripheral characteristic found: \(characteristic.uuid.uuidString) \(characteristic.description)")
                if(characteristic.uuid.uuidString == BT.CharacteristicUUID.uuidString){
                    Globals.log("--s--c--v-- @ Found the right characteristic. Subscribing ...")
                    self.remoteCharacteristic = characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    //handing the update message from subscribed peripheral & characteristics
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == BT.CharacteristicUUID {
            Globals.logToScreen("BT Characteristic update, reading message...")
            if let value = characteristic.value, let message = String(data: value, encoding: .utf8) {
                Globals.logToScreen("BT Received message: \(message)")

                mDataChangeListeners.forEach { $0.onPeripheralDataChange(centralManager, peripheral, characteristic) }
            }
        }
    }
    
    
    //
    //This function is wrinting a value to a connected remote peripheral
    //
    //   func sendText(_ text: String) {
    //       guard let peripheral = self.peripheral,
    //             let service = peripheral.services?.first(where: { $0.uuid == serviceUUID })
    //       else {
    //           Globals.log("Required BT Service not found!")
    //           return
    //       }
    //
    //       guard let characteristic = service.characteristics?.first(where: { $0.uuid == characteristicUUID })
    //       else {
    //           Globals.log("Required BT Characteristic not found!")
    //           return
    //       }
    //
    //       Globals.log("BT Sending: \(text)")
    //       let data = text.data(using: .utf8)!
    //       self.peripheral.writeValue(data, for: characteristic, type: .withResponse)
    //   }

}

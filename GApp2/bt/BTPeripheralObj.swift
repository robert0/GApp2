//
//  BTPeripheralObj.swift
//  GApp
//
//  Created by Robert Talianu
//
import CoreBluetooth
import OrderedCollections
import UIKit

class BTPeripheralObj: NSObject, CBPeripheralManagerDelegate, CBPeripheralDelegate, CBCentralManagerDelegate {
        
    // Properties
    public var peripheralManager: CBPeripheralManager!
    private var centralManager: CBCentralManager!
        
    //local(own peripheral) service & characteristic
    let serviceUUID = CBUUID(string: "0000FFF0-0000-1000-2000-300040005000")
    let characteristicUUID = CBUUID(string: "0000FFF0-0000-1000-2000-300040005001")
    var service: CBMutableService?
    var characteristic: CBMutableCharacteristic?

    //remote connected peripheral
    private var peripheral: CBPeripheral!
    
    private var peripheralsMap = OrderedDictionary<String, CBPeripheral>()
    private var btChangeListener: BTChangeListener?
    var counter: Int = 1
    
    override init() {
        super.init()
        Globals.log("Starting CBPeripheralManager...")
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        centralManager = CBCentralManager(delegate: self, queue: nil)
      }

    /**
     * @param dataChangeListener
     */
    public func setBTChangeListener(_ dataChangeListener: BTChangeListener) {
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

    //called when Peripheral Manager State changes
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            Globals.log("BT CBPeripheralManager is ON. Creating service and characteristic...")
            //when CBPeripheralManager is ON, add new service/characteristic that will be used for communication
            let characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: [.notify, .read, .write], value: nil, permissions: [.readable, .writeable])
            let service = CBMutableService(type: serviceUUID, primary: true)
            service.characteristics = [characteristic]
            peripheralManager.add(service)
            
            //keep local refs
            self.service = service
            self.characteristic = characteristic
            
            Globals.log("BT Start Advertising...")
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
        } else {
            Globals.log("BT Peripheral is not available.")
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
             let service = peripheral.services?.first(where: { $0.uuid == serviceUUID })
       else {
           Globals.log("Required BT Service not found!")
           return
       }
       
       guard let characteristic = service.characteristics?.first(where: { $0.uuid == characteristicUUID })
       else {
           Globals.log("Required BT Characteristic not found!")
           return
       }
       
       Globals.log("BT Sending: \(text)")
       let data = text.data(using: .utf8)!
       self.peripheral.writeValue(data, for: characteristic, type: .withResponse)
   }
    
    
    /**
     *
     */
//    public func gestureEvaluationCompleted(_ gw: GestureWindow, _ status: GestureEvaluationStatus) {
//        Globals.logToScreen("BTPeripheralGesture gestureEvaluationCompleted...")
//        //trigger repaint
//        //onDataChange()
//        
//        guard let peripheralMgr = btpObj?.peripheralManager,
//              let characteristic = btpObj?.characteristic
//        else {
//            Globals.logToScreen("BT message not send. PeripheralMgr or Characteristic not initialized")
//            return
//        }
//        let gkey = status.getGestureKey();
//        let gCorr = status.getGestureCorrelationFactor();
//        let gCorrFt = String(format: self.correlationFactorFormat, gCorr)
//        let jsonDataStr = "{\"gestureKey\":\"\(gkey)\", \"gestureCorrelationFactor\":\(gCorrFt)}"
//        let jsonData = jsonDataStr.data(using: .utf8) ?? Data()
//        
//        
//        //Globals.logToScreen("BT Sending position: \(jsonDataStr)")
//        peripheralMgr.updateValue(jsonData, for: characteristic, onSubscribedCentrals:nil)
//    }
    
    

    
    //on demand single response
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        if request.characteristic.uuid == characteristicUUID {
            Globals.log("BT Peripheral incomming request for characteristicUUID...")
            if let value = request.value, let message = String(data: value, encoding: .utf8) {
                Globals.log("BT Received request message: \(message)")
            }
            if let value = "Hello Central".data(using: .utf8) {
                request.value = value
                peripheralManager.respond(to: request, withResult: .success)
            }
        }
    }
    
    //on demand multiple requests -> inbound message & reply
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if request.characteristic.uuid == characteristicUUID {
                Globals.log("BT Peripheral incomming request(multiple) for characteristicUUID...")
                if let value = request.value, let message = String(data: value, encoding: .utf8) {
                    Globals.log("BT Received request message: \(message)")
                }
                if let value = "Hello Central".data(using: .utf8) {
                    request.value = value
                    peripheralManager.respond(to: request, withResult: .success)
                }
            }
        }
    }
    
    //fail to advertise, retrying
    func peripheralManager(_ peripheral: CBPeripheralManager, didFailToStartAdvertising error: Error?) {
        Globals.log("BT: Failed to start advertising, retrying...")
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
    }
    
    
    //advertising text to all listeners to the defined service & characteristic
    public func advertiseText(_ dataStr:String){
        let jsonData = dataStr.data(using: .utf8) ?? Data()
        
        guard let peripheralMgr = peripheralManager,
              let characteristic = characteristic
        else {
            Globals.log("BT advertiseText failed. PeripheralMgr or Characteristic not initialized!")
            return
        }
        
        //Globals.logToScreen("BT Sending position: \(jsonDataStr)")
        peripheralMgr.updateValue(jsonData, for: characteristic, onSubscribedCentrals:nil)
    }
    
    /**
     *
     * Incomming message from a peripheral that is listened
     *
     * @param btMgr
     * @param peripheral
     * @param data
     */
    func onPeripheralDataChange(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ data: Data?){
        Globals.log("BT: onPeripheralDataChange called..")
        
        //var xx = "{\"gestureKey\":\"KEY\",\"gestureCorrelationFactor\": -12.123}"
        //let gobj1: GestureJson? = decodeDataToObject(data: xx.data(using: .utf8)!)
        //Globals.logToScreen("BT JSON test data: \(gobj1!.gestureCorrelationFactor)")
        
        let gobj: GestureJson? = decodeDataToObject(data: data)
        Globals.log("BT JSON Data: \(gobj?.gestureCorrelationFactor)")
        
        if(gobj?.gestureCorrelationFactor ?? 0.0 > 0.9){
            Globals.log("BTView VALID gesture...")
            //executeCmd(gobj)
            
        }
    }
    
    //decode data to json object
    func decodeDataToObject<T: Codable>(data : Data?)->T?{
        
        if let dt = data{
            do{
                
                return try JSONDecoder().decode(T.self, from: dt)
                
            }  catch let DecodingError.dataCorrupted(context) {
                Globals.logToScreen("JSON " + context.debugDescription)
                
            } catch let DecodingError.keyNotFound(key, context) {
                Globals.logToScreen("JSON - Key '\(key)' not found:" + context.debugDescription)
                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
                
            } catch let DecodingError.valueNotFound(value, context) {
                Globals.logToScreen("JSON - Value '\(value)' not found:" + context.debugDescription)
                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
                
            } catch let DecodingError.typeMismatch(type, context)  {
                Globals.logToScreen("JSON - Type '\(type)' mismatch:" + context.debugDescription)
                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
                
            } catch {
                Globals.logToScreen("JSON - error: " + error.localizedDescription)
            }
        }
        
        return nil
    }

}

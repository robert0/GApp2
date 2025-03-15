//
//  BTPeripheralObj.swift
//  GApp
//
//  Created by Robert Talianu
//
import CoreBluetooth
import OrderedCollections
import UIKit

class BTPeripheralObj_OUT: NSObject, CBPeripheralManagerDelegate, CBPeripheralDelegate {
        
    // Properties
    public var peripheralManager: CBPeripheralManager!
        
    //local(own peripheral) service & characteristic
    var advertiseService: CBMutableService?
    var advertiseCharacteristic: CBMutableCharacteristic?

    var counter: Int = 1
    
    override init() {
        super.init()
        Globals.log("Starting CBPeripheralManager...")
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
      }

    

    //called when Peripheral Manager State changes
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            Globals.log("BT CBPeripheralManager is ON. Creating service and characteristic...")
            //when CBPeripheralManager is ON, add new service/characteristic that will be used for communication
            let characteristic = CBMutableCharacteristic(type: BT.CharacteristicUUID, properties: [.notify, .read, .write], value: nil, permissions: [.readable, .writeable])
            let service = CBMutableService(type: BT.ServiceUUID, primary: true)
            service.characteristics = [characteristic]
            peripheralManager.add(service)
            
            //keep local refs
            self.advertiseService = service
            self.advertiseCharacteristic = characteristic
            
            Globals.log("BT Start Advertising...")
            peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [BT.ServiceUUID]])
        } else {
            Globals.log("BT Peripheral is not available.")
        }
    }
    
    //on demand single request
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        if request.characteristic.uuid == BT.CharacteristicUUID {
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
            if request.characteristic.uuid == BT.CharacteristicUUID {
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
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [BT.ServiceUUID]])
    }
    
    
    //advertising text to all listeners to the defined service & characteristic
    public func advertiseText(_ dataStr:String){
        let jsonData = dataStr.data(using: .utf8) ?? Data()
        
        guard let peripheralMgr = peripheralManager,
              let characteristic = advertiseCharacteristic
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

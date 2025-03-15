
import CoreBluetooth
import UIKit

//class BluetoothViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
//
//    var centralManager: CBCentralManager!
//    var peripheral: CBPeripheral!
//    var currentCharacteristic: CBCharacteristic! = nil
//    var readRSSITimer: Timer!
//    var RSSIholder: Int = 0
//    let txCharacteristic = CBUUID(string: "6e400002-b5a3-f393-XXXX-e50e24dXXXXX")
//    
//    /**
//     *
//     */
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.startManager()
//    }
//
//    /**
//     *
//     */
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    /**
//     *
//     */
//    func centralManagerDidUpdateState(central: CBCentralManager) {
//        if (central.state == CBCentralManagerState.PoweredOn) {
//            self.centralManager?.scanForPeripheralsWithServices(nil, options: nil)
//        } else {
//            print("BLE not on")
//        }
//    }
//    
//    /**
//     *
//     */
//    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
//        if (peripheral.name != nil && peripheral.name! == "NAME"){
//            self.peripheral = peripheral
//            self.centralManager.connectPeripheral(self.peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey : true])
//        }
//    }
//    
//    /**
//     *
//     */
//    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
//        peripheral.readRSSI()
//        self.startReadRSSI()
//        peripheral.delegate = self
//        peripheral.discoverServices(nil)
//        print("connected to \(peripheral)")
//        self.stopScan()
//    }
//    
//    /**
//     *
//     */
//    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?){
//        self.stopReadRSSI()
//        if self.peripheral != nil {
//            self.peripheral.delegate = nil
//            self.peripheral = nil
//        }
//        print("did disconnect", error)
//        self.startManager()
//    }
//    
//    /**
//     *
//     */
//    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?){
//        print("connection failed", error)
//    }
//    
//    /**
//     *
//     */
//    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?){
//        peripheral.discoverCharacteristics(nil, forService: peripheral.services![0])
//    }
//    
//    
//    /**
//     *
//     */
//    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?){
//        for characteristic in service.characteristics! {
//            let thisCharacteristic = characteristic as CBCharacteristic
//            if thisCharacteristic.UUID == txCharacteristic{
//                self.currentCharacteristic = thisCharacteristic
//            }
//        }
//        if let error = error {
//            print("characteristics error", error)
//        }
//    }
//    
//    /**
//     *
//     */
//    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?){
//        if let error = error {
//            print("updated error", error)
//        }
//    }
//    
//    /**
//     *
//     */
//    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?){
//        if let error = error {
//            print("Writing error", error)
//        } else {
//            print("Succeeded")
//        }
//    }
//    
//    /**
//     *
//     */
//    func stopScan(){
//        self.centralManager.stopScan()
//    }
//    
//    /**
//     *
//     */
//    func startManager(){
//        centralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
//    }
//    
//    /**
//     *
//     */
//    func peripheral(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?) {
//        self.RSSIholder = RSSI.intValue
//    }
//    
//    /**
//     *
//     */
//    func readRSSI(){
//        if (self.peripheral != nil){
//            self.peripheral.delegate = self
//            self.peripheral.readRSSI()
//        } else {
//            print("peripheral = nil")
//        }
//        if (Int(self.RSSIholder) > -70) {
//            let openValue = "1".dataUsingEncoding(NSUTF8StringEncoding)!
//            self.peripheral.writeValue(openValue, forCharacteristic: self.currentCharacteristic, type: CBCharacteristicWriteType.WithResponse)
//        }
//    }
//    
//    /**
//     *
//     */
//    func startReadRSSI() {
//        if self.readRSSITimer == nil {
//            self.readRSSITimer = Timer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.readRSSI), userInfo: nil, repeats: true)
//        }
//    }
//    
//    /**
//     *
//     */
//    func stopReadRSSI() {
//        if (self.readRSSITimer != nil){
//            self.readRSSITimer.invalidate()
//            self.readRSSITimer = nil
//        }
//    }
//}

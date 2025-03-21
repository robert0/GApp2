//
//  BTView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI
import CoreBluetooth

struct BTView: View, BTChangeListener {
    @Environment(\.dismiss) var dismiss

    static var btoInstance: BTCentralObj_IN?
    
    @ObservedObject var viewModel = BTViewModel()
    @State private var selection: String?
    
    init() {
       //TODO ... link to gesture events
    }
    
    // The bluetooth panel
    var body: some View {
        return VStack {
            Text("Choose Bluetooth device to connect:")
                .font(.title3)
            //Button("Press to start Bluetooth Advertising", action: startBTAdvertising)
            //Button("Press for Bluetooth Gestures streaming", action: streamAccelerometerGestureData)
            
            let entries = BTView.btoInstance?.getPeripheralMap() ?? [:]
            if !entries.isEmpty {
                VStack {
                    Text("Scanning...")
                    List(selection: $selection) {
                        ForEach(entries.elements, id: \.key) { key, value in
                            if(value.name != nil) {//allow only named BTs
                                Text(value.name!)
                            }
                        }
                        .padding(.bottom)
                    }
                    .frame(width: nil, height: 300)
                    .background(Color.white)
                    
                    Button("Connect", action: connectToBTDevice)
                        .disabled(selection == nil)
                }.background(Color.white).padding(20)
            }
            
        }.onAppear {
            Globals.log("BTView onAppear..")
            //used for UI forced updates
            viewModel.updateCounter = viewModel.updateCounter + 1
            if( BTView.btoInstance == nil){
                Globals.log("BTView add bt listener...")
                BTView.btoInstance = GApp2App.startBTInbound()//ensure BT is started (usually a single instance is created)
                BTView.btoInstance!.addBTChangeListener(self)//add/set listener only once
            }
            GApp2App.startBTScanning()
            
        }.onDisappear{
            Globals.log("BTView onDisappear..")
            GApp2App.stopBTScanning()
        }
    }
    
    /**
     *
     */
    func connectToBTDevice() {
        let entries = BTView.btoInstance?.getPeripheralMap()
        let cbp:CBPeripheral? = entries?[self.selection!]
        print("connectToBTDevice called..\(cbp?.identifier)")
        
        if(cbp != nil){
            GApp2App.connectToBTDevice(cbp!)
        } else {
            print("Device not found in BT devices list..")
        }
        
        dismiss()
    }
    
    /**
     *
     */
    func onManagerDataChange(_ central: CBCentralManager) {
        print("onManagerDataChange called..")
    }
    
    /**
     *
     */
    func onPeripheralChange(_ central: CBCentralManager, _ peripheral: CBPeripheral) {
        print("onPeripheralChange called.. \(BTView.btoInstance?.getPeripheralMap().count) _ \(self.viewModel.updateCounter)")
        self.viewModel.updateCounter = self.viewModel.updateCounter + 1
    }
    
    /**
     *
     */
    func onPeripheralDataChange(_ central: CBCentralManager, _ peripheral: CBPeripheral, _ characteristic:CBCharacteristic){
        print("onPeripheralDataChange called..")
    }
}

//
// Helper class for DataView that handles the updates
//
// Created by Robert Talianu
//
final class BTViewModel: ObservableObject {
    @Published var updateCounter: Int = 1
    @Published var selection: String?
}

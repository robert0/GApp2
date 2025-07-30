import CoreMotion
//
//  ManageGesturesView.swift
//  GApp2
//
//  Created by Robert Talianu
//
import SwiftUI
import Foundation
import WatchConnectivity
import SwiftUICore

struct ChooseSourceView: View {
    @Environment(\.dismiss) var dismiss
    let session = WCSession.default
    
    var gesturesStore:MultiGestureStore
    
    // constructor
    init( _ gesturesStore: MultiGestureStore) {
        self.gesturesStore = gesturesStore
     
    }
        
    // The app panel
    var body: some View {
        return VStack (alignment: .leading){
            //add buttons
            Text("Available Gesture Sources:")
                .font(.title3)
            Spacer().frame(height: 30)
            
            let source = RawGestureDeviceRouter.shared.deviceType
            if (source == nil || source == DeviceType.Phone){
                //use highlighted button
                Button("Use this phone", systemImage:"iphone.homebutton.radiowaves.left.and.right", action: {
                    Globals.log("Use this phone clicked")
                    RawGestureDeviceRouter.setSourceToThisPhone()
                    dismiss()
                    
                }).buttonStyle(.borderedProminent)
                
            } else {
                //use plain button
                Button("Use this phone", systemImage:"iphone.homebutton.radiowaves.left.and.right", action: {
                    Globals.log("Use this phone clicked")
                    RawGestureDeviceRouter.setSourceToThisPhone()
                    dismiss()
                    
                }).buttonStyle(.plain)
            }
            Spacer().frame(height: 30)
            
            if (source == DeviceType.Watch){
                //use highlighted button
                Button("Use paired iWatch", systemImage:"watch.analog", action: {
                    Globals.log("Use paired Watch clicked")
                    RawGestureDeviceRouter.setSourceToPairedWatch()
                    dismiss()
                    
                })
                .buttonStyle(.borderedProminent)
                .disabled(!GApp2App.isWatchConnectivityActive())
                
            } else {
                //use plain button
                Button("Use paired iWatch", systemImage:"watch.analog", action: {
                    Globals.log("Use paired Watch clicked")
                    RawGestureDeviceRouter.setSourceToPairedWatch()
                    dismiss()
                    
                })
                .buttonStyle(.plain)
                .disabled(!GApp2App.isWatchConnectivityActive())
            }
            Spacer().frame(height: 50)
            
            
            if(!GApp2App.isWatchConnectivityActive()){
                Text("Warning: Watch connection is not active! Check bluetooth, network or that app is also running on watch.")
                    .foregroundColor(.gray)
                    .italic()
                    .font(.footnote)
            }
            
//            if (source == DeviceType.BTPhone){
//                //use highlighted button
//                Button("Use paired phone", systemImage:"iphone.sizes", action: {
//                    Globals.log("Use paired phone clicked !!!...")
//                    RawGestureDeviceRouter.setSourceToBTPhone()
//                    dismiss()
//                    
//                }).buttonStyle(.borderedProminent).disabled(true)
//                
//            } else {
//                //use plain button
//                Button("Use paired phone", systemImage:"iphone.sizes", action: {
//                    Globals.log("Use paired phone clicked !!!...")
//                    RawGestureDeviceRouter.setSourceToBTPhone()
//                    dismiss()
//                    
//                }).buttonStyle(.plain).disabled(true)
//            }
            Spacer()
            
              
        }.onAppear {
            checkConnectivity()
        }
    }
    
    
    func checkConnectivity() {
        print("ChooseSourceView: checking watch connectivity...")
        WDConnector.printState(WCSession.default)
    }
}




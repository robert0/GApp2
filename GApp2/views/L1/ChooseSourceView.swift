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
    @State var counter:Int = 0
    
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
                    Globals.log("Use this phone clicked !!!...")
                    RawGestureDeviceRouter.setSourceToThisPhone()
                    dismiss()
                    
                }).buttonStyle(.borderedProminent)
                
            } else {
                //use plain button
                Button("Use this phone", systemImage:"iphone.homebutton.radiowaves.left.and.right", action: {
                    Globals.log("Use this phone clicked !!!...")
                    RawGestureDeviceRouter.setSourceToThisPhone()
                    dismiss()
                    
                }).buttonStyle(.plain)
            }
            Spacer().frame(height: 30)
            
            if (source == DeviceType.Watch){
                //use highlighted button
                Button("Use paired iWatch", systemImage:"watch.analog", action: {
                    Globals.log("Use paired Watch clicked !!!...")
                    RawGestureDeviceRouter.setSourceToPairedWatch()
                    dismiss()
                    
                }).buttonStyle(.borderedProminent)
                
            } else {
                //use plain button
                Button("Use paired iWatch", systemImage:"watch.analog", action: {
                    Globals.log("Use paired Watch clicked !!!...")
                    RawGestureDeviceRouter.setSourceToPairedWatch()
                    dismiss()
                    
                }).buttonStyle(.plain)
            }
            Spacer().frame(height: 30)
            
            
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
            //used for UI forced updates
            counter = counter + 1
            checkConnectivity()
        }
    }
    
    
    func checkConnectivity() {
        
        // Perform any final initialization of your application.
        if WCSession.isSupported() {
            print("ChooseSourceView: Check watch connectivity - WCSession is Supported!")
        } else {
            print("ChooseSourceView: Check watch connectivity - WCSession is not Supported!")
        }
        
        // Perform any final initialization of your application.
        if session.isPaired {
            print("ChooseSourceView:  Check watch connectivity - iWatch is Paired!")
        } else {
            print("ChooseSourceView: Check watch connectivity - iWatch is NOT Paired!")
        }
        
        // Perform any final initialization of your application.
        if session.isReachable {
            print("ChooseSourceView:  Check watch connectivity - iWatch is Reachable!")
        } else {
            print("ChooseSourceView: Check watch connectivity - iWatch is NOT Reachable!")
        }
    }
}




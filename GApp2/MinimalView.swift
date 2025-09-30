//
//  ContentView.swift
//  GApp2
//
//  Created by Robert Talianu
//

import SwiftUI

struct MinimalView: View {
    //logger view wg
    private var logView: LogView
    var gesturesStore:MultiGestureStore
    var inGesturesStore:InGestureStore
    var gestureAnalyser:RealtimeMultiGestureStoreAnalyser
    @State var gCount:Int = 0
    @State var inGCount:Int = 0
    
    init () {
        //initilize local vars
        self.gesturesStore = MultiGestureStore()
        self.inGesturesStore = InGestureStore()
        GApp2App.gestureDispatcher.setGestureStore(gesturesStore)
        GApp2App.gestureDispatcher.setInGestureStore(inGesturesStore)
        self.gestureAnalyser = RealtimeMultiGestureStoreAnalyser(gesturesStore)
        self.gestureAnalyser.addEvaluationListener(GApp2App.gestureDispatcher)
        
        self.logView = LogView()
        Globals.setChangeCallback(self.logView.logCallbackFunction)
        
        //load saved gestures from filesystem
        let gestures = FileSystem.readLocalGesturesDataFile()
        Globals.log("Loaded gestures count: \(gestures.count)")
        if gestures.count > 0 {
            gestures.forEach({
                self.gesturesStore.setGesture($0.getName(), $0)
            })
        }
        
        
        //load saved incomming gestures mappings from filesystem
        let igestures = FileSystem.readIncommingGesturesMappingDataFile()
        Globals.log("Loaded incomming gestures mapping count: \(igestures.count)")
        if igestures.count > 0 {
            igestures.forEach({
                //set global key as reference
                self.inGesturesStore.setGestureMapping($0.getIncommingGKey(), $0)
            })
        }
        
        //load saved ssh data from filesystem
        let sshDataBean = FileSystem.readSshDataBeanFile()
        Globals.log("Loaded ssh data for: \(sshDataBean?.hostname)")
        if sshDataBean != nil {
            GApp2App.setSshDataBean(sshDataBean!)
        }
        
        //start bluetooth & advertising
        GApp2App.startBTOutbound()
        
        //start the watch connectivity
        GApp2App.activateWatchConnectivity()
        
        var _self = self
        
        //start HID interface
        GApp2App.activateHIDInterface()
            
        //Notify App started OK
        ToastManager.show("App started...OK", ToastSeverity.info)
            
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack (alignment: .center) {
                    TestView(gestureAnalyser)
                    Spacer()
                   
                    Text("Gestures App v1.8.4")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 150, alignment: .trailing)
                }
                .onAppear {
                    gCount = gesturesStore.getKeys()?.count ?? 0
                    inGCount = inGesturesStore.getKeys().count
                }
            }
            
            //Toast container for showing notifications
            ToastsContainerView()
                .environmentObject(ToastManager.shared)
        }
        Spacer()
    }
}

#Preview {
    MinimalView()
}

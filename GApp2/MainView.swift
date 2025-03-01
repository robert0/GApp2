//
//  ContentView.swift
//  GApp2
//
//  Created by Robert Talianu
//

import SwiftUI

struct MainView: View {
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
        self.gestureAnalyser = RealtimeMultiGestureStoreAnalyser(gesturesStore)
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
                self.inGesturesStore.setGestureMapping($0.getName(), $0)
            })
        }
    }
    
    var body: some View {
          
            NavigationView {
                VStack (alignment: .leading) {
                    Spacer()
                    NavigationLink(destination: ChooseSourceView(gesturesStore)) {
                        Image(systemName: "applewatch.radiowaves.left.and.right")
                            .imageScale(.large)
                        Text("Choose Source")
                    }
                    Spacer().frame(height:30)
                    NavigationLink(destination: CreateGestureView(gesturesStore)) {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                        Text("Create Gesture")
                    }
                    Spacer().frame(height:30)
                    NavigationLink(destination: ManageGesturesView(gesturesStore)) {
                        Image(systemName: "pencil")
                            .imageScale(.large)
                        Text("Manage Gestures ( \(gCount) )")
                    }
                    Spacer().frame(height:30)
                    NavigationLink(destination: IncommingGesturesView(inGesturesStore)) {
                        Image(systemName: "iphone.and.arrow.right.inward")
                            .imageScale(.large)
                        Text("Incomming Gestures ( \(inGCount) )")
                    }
                    Spacer().frame(height:30)
                    NavigationLink(destination: TestGesturesView(gestureAnalyser)) {
                        Image(systemName: "play")
                            .imageScale(.large)
                        Text("Test")
                    }
                    Spacer()
                    Text("Gestures App v1.4")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 150, alignment: .trailing)
                }
                .onAppear {
                    gCount = gesturesStore.getKeys()?.count ?? 0
                    inGCount = inGesturesStore.getKeys().count
                }
            }
            Spacer()
    }
}

#Preview {
    MainView()
}

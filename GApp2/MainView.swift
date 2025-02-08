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
    var gestureAnalyser:RealtimeMultiGestureStoreAnalyser
    @State var viewCount:Int = 0
    
    init () {
        //initilize local vars
        self.gesturesStore = MultiGestureStore()
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
                        Text("Manage Gestures ( \(viewCount) )")
                    }
                    Spacer().frame(height:30)
                    NavigationLink(destination: TestGesturesView(gestureAnalyser)) {
                        Image(systemName: "play")
                            .imageScale(.large)
                        Text("Test")
                    }
                    Spacer()
                    
                }
                .onAppear {
                    viewCount = gesturesStore.getKeys()?.count ?? 0
                }
            }
            Spacer()
    }
}

#Preview {
    MainView()
}

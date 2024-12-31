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
    }
    
    var body: some View {
          
            NavigationView {
                VStack {
                    Spacer()
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
                    
                }.onAppear {
                    viewCount = gesturesStore.getKeys()?.count ?? 0
                }
            }
            Spacer()
    }
}

#Preview {
    MainView()
}

import CoreMotion
//
//  AppTabView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI

struct TestGesturesView: View {
    //next vars will be created only once
    private var analyser:RealtimeMultiGestureStoreAnalyser
    private static var dataRenderer: TestingViewRenderer?
    private static var eventsHandler: AccelerometerEventStoreHandler?

    // constructor
    init(_ analyser:RealtimeMultiGestureStoreAnalyser) {
        //the init will be called every time the user goes away from this page.(the parent has a reference to it, so it will be recreated)
        Globals.log("Testing gesture view, init() ...")
        //Create & link Gesture Analyser
        self.analyser = analyser
        
        if(TestGesturesView.dataRenderer == nil){
            initializeStatics();
        } else {
            cleanUp() //otherview do cleanup of static data
        }
    }
        
    //
    func initializeStatics(){
        //Create the view  and wire it
        TestGesturesView.dataRenderer = TestingViewRenderer()
        TestGesturesView.dataRenderer!.setDataProvider(analyser)
        
        self.analyser.setChangeListener(TestGesturesView.dataRenderer)
        self.analyser.addEvaluationListener(TestGesturesView.dataRenderer)
        
        //connect to the data supplier
        Globals.logToScreen("Initializing Sensor Manager...")
        DeviceRouter.addListener(analyser)

    }
    
    //used to clean view & cached data
    func cleanUp(){
        
    }
    
    
    // The app panel
    var body: some View {
        return VStack {
            //add buttons
            HStack {
                Spacer()
                Button("Test") {
                    Globals.log("Testing Clicked !!!...")
                    if(DeviceRouter.shared.deviceType == nil){
                        DeviceRouter.setSourceToThisPhone()
                    }
                    
                    DeviceRouter.startStreaming()
                    self.analyser.startAnalysing()
                  
                }.buttonStyle(.borderedProminent)
                Spacer().frame(width: 10)
                
                Button("Stop Testing") {
                    Globals.log("Stop Testing Clicked !!!...")
                    self.analyser.stopAnalysing()
                    DeviceRouter.stopStreaming()

                }.buttonStyle(.borderedProminent)
                Spacer().frame(width: 10)
               
//                Button("Execute App") {
//                    Globals.log("Execute App Clicked !!!...")
//                    let url = URL(string: "https://www.bing.com")
//                    UIApplication.shared.open(url!)
//
//                }.buttonStyle(.borderedProminent)
                Spacer()
            }

            HStack {
                Spacer()
                Button("Send Click Message") {
                    Globals.log("Send Watch A .click Message!!!...")
                    GApp2App.sendWatchAMessage(".click")

                }.buttonStyle(.borderedProminent)
                Spacer().frame(width: 10)
                
                Button("Send 2 Click Message") {
                    Globals.log("Send Watch A 2.click Message!!!...")
                    GApp2App.sendWatchAMessage(".click2")

                }.buttonStyle(.borderedProminent)
                Spacer().frame(width: 10)
                
                Button("Send 3 Click Message") {
                    Globals.log("Send Watch A 3.click Message!!!...")
                    GApp2App.sendWatchAMessage(".click3")

                }.buttonStyle(.borderedProminent)
                Spacer().frame(width: 10)
                Spacer()
            }
            
            //add data view panel
            TestGesturesView.dataRenderer
            
        }.onDisappear {
            //force stop streaming
            self.analyser.stopAnalysing()
            DeviceRouter.stopStreaming()
            //self.analyser.clear() - to be implemented
        }
    }
}

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
        SensorMgr.addListener(analyser)
        SensorMgr.startAccelerometers(Device.View_Accelerometer_Interval)
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
                    self.analyser.startStreaming()
                  
                }.buttonStyle(.borderedProminent)
                Spacer().frame(width: 10)
                
                Button("Stop Testing") {
                    Globals.log("Stop Testing Clicked !!!...")
                    self.analyser.stopStreaming()

                }.buttonStyle(.borderedProminent)
                Spacer().frame(width: 10)
                
                Button("Execute App") {
                    Globals.log("Execute App Clicked !!!...")
                    let url = URL(string: "https://www.bing.com")
                    UIApplication.shared.open(url!)

                }.buttonStyle(.borderedProminent)
                Spacer()
               
            }

            //add data view panel
            TestGesturesView.dataRenderer
        }
    }
}

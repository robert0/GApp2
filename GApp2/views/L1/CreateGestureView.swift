import CoreMotion
//
//  AppTabView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI

struct CreateGestureView: View, DataChangeListener {
  
    private var store: RealtimeSingleGestureStore
    private var eventsHandler: AccelerometerEventHandler2
    private var dataRenderer: CreateGestureDataRenderer

    // The app panel
    var body: some View {
        return VStack {
            //add buttons
           
            Spacer()
            Button("Start Recording") {
                Globals.logToScreen("Start Recording Pressed")
                eventsHandler.clearRecordingData()
                eventsHandler.startStreaming()
                //TODO... update keys iterator
            }
        
            //add data renderer view panel
            dataRenderer
            
            Spacer().frame(height: 20)
            Button("Save gesture") {
                Globals.logToScreen("Save gesture Pressed")
            }
            Spacer()
        }
    }

    // constructor
    init() {

        //Create & link Gesture Analyser
        store = RealtimeSingleGestureStore()

        //Create the view  and wire it
        dataRenderer = CreateGestureDataRenderer()
        dataRenderer.setDataProvider(store)

        //Create & link accelerometer events handler
        eventsHandler = AccelerometerEventHandler2(store)
        Globals.logToScreen("Event handler created...")

        //pview.setStateProvider(eventsHandler);
        self.store.addChangeListener(dataRenderer)
        self.store.addChangeListener(self)
        Globals.logToScreen("Gesture analyser created and wired...")
        
        // Create a CMMotionManager instance
        Globals.logToScreen("Initializing Sensor Manager...")
        SensorMgr.registerListener(eventsHandler)
        SensorMgr.startAccelerometers(Device.View_Accelerometer_Interval)

        Globals.logToScreen("Starting mock generator...")
        MockGenerator.start()
        Globals.logToScreen("Mock generator connected...")

    }
    
    func onDataChange(_ type: Int) {
        if(type == RealtimeSingleGestureStore.DATA_COMPLETE_UPDATE){
            eventsHandler.stopStreaming()
            store.recomputeMean()
        }
    }
}

import CoreMotion
//
//  AppTabView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI

struct CreateGestureView: View, DataChangeListener {
  
    private var store: RealtimeMultiGestureStore
    private var eventsHandler: AccelerometerEventHandler2
    private var dataRenderer: CreateGestureDataRenderer

    // The app panel
    var body: some View {
        return VStack {
            //add buttons
            HStack {
                Spacer()
                Button("Start Recording") {
                    Globals.logToScreen("Start Recording Pressed")
                    eventsHandler.clearRecordingData()
                    eventsHandler.startStreaming()
                    //TODO... update keys iterator
                }
                Spacer()
                Button("Save gesture") {
                    Globals.logToScreen("Save gesture Pressed")
                }
            }

            //add data renderer view panel
            dataRenderer
        }
    }

    // constructor
    init() {

        //Create & link Gesture Analyser
        store = RealtimeMultiGestureStore()

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
        if(type == 1){
            eventsHandler.stopStreaming()
        }
    }
}

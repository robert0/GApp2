import CoreMotion
//
//  AppTabView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI

struct TestGesturesView: View {
    private var analyser: RealtimeMultiGestureStoreAnalyser
    //private var eventsHandler: AccelerometerEventHandler
    private var dataView: DataView

    // The app panel
    var body: some View {
        return VStack {
            //add buttons
            HStack {
                Spacer()
                Button("Test") {
                    Globals.logToScreen("Testing Clicked !!!...")
                    //eventsHandler.clearTestingData()
                    //eventsHandler.setToRealtimeTesting()
                    //TODO... update keys iterator
                }
                Button("Mock") {
                    //MockGenerator.toggleListener()
                    Globals.logToScreen("Mock Button Pressed")
                    //MockGenerator.toggleListener(eventsHandler)
                }
                Spacer()
            }

            //add data view panel
            dataView
        }
    }

    // constructor
    init(_ analyser: RealtimeMultiGestureStoreAnalyser) {

        //Create & link Gesture Analyser
        self.analyser = analyser

        //Create the view  and wire it
        dataView = DataView()
        //dataView.setDataProvider(analyser)

        //pview.setStateProvider(eventsHandler);
        self.analyser.setChangeListener(dataView)
        self.analyser.addEvaluationListener(dataView)
        Globals.logToScreen("Gesture analyser created and wired...")

        //Create & link accelerometer events handler
        //eventsHandler = AccelerometerEventHandler(analyser)
        Globals.logToScreen("Event handler created...")

        // Create a CMMotionManager instance
        Globals.logToScreen("Initializing Sensor Manager...")
        //SensorMgr.registerListener(eventsHandler)
        //SensorMgr.startAccelerometers(Device.View_Accelerometer_Interval)

        Globals.logToScreen("Starting mock generator...")
        MockGenerator.start()
        Globals.logToScreen("Mock generator connected...")

    }
}

import CoreMotion
//
//  CreateGestureView.swift
//  GApp2
//
//  Created by Robert Talianu
//
import SwiftUI

struct CreateGestureView: View, DataChangeListener {
    @Environment(\.dismiss) var dismiss
    
    //next vars will be created only once
    private var allGesturesStore:RealtimeMultiGestureStoreAnalyser
    private static var singleGestureStore: RealtimeSingleGestureStore?
    private static var dataRenderer: CreateGestureDataRenderer?
    private static var eventsHandler: AccelerometerEventStoreHandler?
   
    ///local vars
    @State private var name: String = ""
    @State private var isNameMissing: Bool = true

    // constructor
    init(_ gesturesStore:RealtimeMultiGestureStoreAnalyser) {
        //the init will be called every time the user goes away from this page.(the parent has a reference to it, so it will be recreated)
        Globals.log("Create gesture view, init() ...")
        self.allGesturesStore = gesturesStore
        
        if(CreateGestureView.singleGestureStore == nil){
            initializeStatics();
        } else {
            cleanUp() //otherview do cleanup of static data
        }
    }
    
    //
    func initializeStatics(){
        //Create & link Gesture Analyser
        CreateGestureView.singleGestureStore = RealtimeSingleGestureStore()

        //Create the view  and wire it
        CreateGestureView.dataRenderer = CreateGestureDataRenderer()
        CreateGestureView.dataRenderer!.setDataProvider(CreateGestureView.singleGestureStore!)

        //Create & link accelerometer events handler
        CreateGestureView.eventsHandler = AccelerometerEventStoreHandler()
        CreateGestureView.eventsHandler!.setStore(CreateGestureView.singleGestureStore!)
        Globals.logToScreen("Event handler created...")

        //pview.setStateProvider(eventsHandler);
        CreateGestureView.singleGestureStore!.addChangeListener(CreateGestureView.dataRenderer!)
        CreateGestureView.singleGestureStore!.addChangeListener(self)
        Globals.logToScreen("Gesture analyser created and wired...")
        
        // Create a CMMotionManager instance
        Globals.logToScreen("Initializing Sensor Manager...")
        SensorMgr.addListener(CreateGestureView.eventsHandler!)
        SensorMgr.startAccelerometers(Device.View_Accelerometer_Interval)
    }
    
    // The app panel
    var body: some View {
        
        return VStack {
            //add buttons
           
            Spacer()
            Button("Start Recording") {
                Globals.logToScreen("Start Recording Pressed")
                if(CreateGestureView.eventsHandler != nil){
                    CreateGestureView.eventsHandler!.clearRecordingData()
                    CreateGestureView.eventsHandler!.startStreaming()
                }

                //TODO... update keys iterator
            }.buttonStyle(.borderedProminent)
        
            //add data renderer view panel
            CreateGestureView.dataRenderer
            Spacer().frame(height: 20)
            
            TextField("Enter gesture name", text: $name)
                .textFieldStyle(.plain)
                .padding(10)
                .contentMargins(5)
                .onChange(of: name) { _ in
                    isNameMissing = name.isEmpty
                }
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(isNameMissing ? Color.red : Color.gray))
                
            
            Button("Save gesture") {
                allGesturesStore.setData(name, CreateGestureView.singleGestureStore!.getRecordingData())
                               
                //return to previous view
                dismiss()
                
            }.buttonStyle(.borderedProminent)
             .disabled(name.isEmpty)
            
            Spacer()
            
        }
    }
    
//    func presentDialog(){
//        // create the actual alert controller view that will be the pop-up
//        let alertController = UIAlertController(title: "New Folder", message: "name this folder", preferredStyle: .alert)
//
//        alertController.addTextField { (textField) in
//            // configure the properties of the text field
//            textField.placeholder = "Name"
//        }
//
//
//        // add the buttons/actions to the view controller
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
//
//            // this code runs when the user hits the "save" button
//
//            let inputName = alertController.textFields![0].text
//            print(inputName)
//        }
//
//        alertController.addAction(cancelAction)
//        alertController.addAction(saveAction)
//
//        self.present(alertController, animated: true, completion: nil)
//    }

    func onDataChange(_ type: Int) {
        if(type == RealtimeSingleGestureStore.DATA_COMPLETE_UPDATE){
            CreateGestureView.eventsHandler!.stopStreaming()
            CreateGestureView.singleGestureStore!.recomputeMeanFromRecordingSignal()
        }
    }
    
    func cleanUp(){
        Globals.log("cleanup...")
        CreateGestureView.singleGestureStore!.clearRecording()
        CreateGestureView.singleGestureStore!.clearGestureMean()
    }
}

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
    private var allGesturesStore:MultiGestureStore
    private static var singleGestureStore: RealtimeSingleGestureStore?
    private static var dataRenderer: CreateGestureDataRenderer?
    private static var eventsHandler: AccelerometerEventStoreHandler?
   
    ///local vars
    @State private var name: String = ""
    @State private var isNameMissing: Bool = true
    private var gUUID: String = ""

    // constructor
    init(_ gesturesStore:MultiGestureStore) {
        //the init will be called every time the user goes away from this page.(the parent has a reference to it, so it will be recreated)
        Globals.log("Create gesture view, init() ...")
        self.allGesturesStore = gesturesStore
        
        //reinitialize UUID
        self.gUUID = UUID().uuidString
        
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
        RawGestureDeviceRouter.addListener(CreateGestureView.eventsHandler!)
    }
    
    // The app panel
    var body: some View {
        
        return VStack {
            //add buttons
           
            Spacer()
            HStack {
                Button("Start Recording") {
                    Globals.logToScreen("Start Recording Pressed")
                    if(RawGestureDeviceRouter.shared.deviceType == nil){
                        RawGestureDeviceRouter.setSourceToThisPhone()
                    }
                    if(CreateGestureView.eventsHandler != nil){
                        CreateGestureView.eventsHandler!.clearRecordingData()
                        RawGestureDeviceRouter.startStreaming()
                        CreateGestureView.eventsHandler!.startRecording()
                    }
                    
                    CreateGestureView.dataRenderer?.setToRecodingMode(true)
                    
                    //TODO... update keys iterator
                }.buttonStyle(.borderedProminent)
                Spacer().frame(width: 20)
                
                Button("Reset Avg") {
                    Globals.log("Reset Avg Clicked !!!...")
                    CreateGestureView.singleGestureStore!.clearGestureMean()
                    CreateGestureView.dataRenderer!.onDataChange(1)
                    
                }.buttonStyle(.borderless)
            }
            
            //add data renderer view panel
            CreateGestureView.dataRenderer
            Spacer().frame(height: 20)
            
            TextField("Enter gesture name", text: $name)
                .textFieldStyle(.plain)
                .padding(10)
                .contentMargins(10)
                .onChange(of: name) { _ in
                    isNameMissing = name.isEmpty
                }
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(isNameMissing ? Color.red : Color.gray))
                
            
            Button("Save gesture") {
                // create gesture with the same name
                let gs = Gesture4D()
                gs.setUUID(self.gUUID)
                gs.setName(self.name)
                gs.setData(CreateGestureView.singleGestureStore!.getRecordingData() ?? [])
                
                //save data to store/analyser
                allGesturesStore.setGesture(self.name, gs)
                               
                //return to previous view
                dismiss()
                
            }.buttonStyle(.borderedProminent)
             .disabled(name.isEmpty)
            
            Spacer()
            
        }.onDisappear {
            //force stop streaming
            CreateGestureView.eventsHandler!.stopRecording()
            RawGestureDeviceRouter.stopStreaming()
        }
    }
    
    //
    func onDataChange(_ type: Int) {
        if(type == RealtimeSingleGestureStore.DATA_COMPLETE_UPDATE){
            CreateGestureView.eventsHandler!.stopRecording()
            RawGestureDeviceRouter.stopStreaming()
            CreateGestureView.singleGestureStore!.recomputeMeanFromRecordingSignal()
            
            //publish data to global sever
            publishGestureOnGlobalServer(data:CreateGestureView.singleGestureStore!.getRecordingData() ?? [])
        }
    }
    
    //
    func cleanUp(){
        Globals.log("cleanup...")
        CreateGestureView.singleGestureStore!.clearGesture()
        CreateGestureView.singleGestureStore!.clearGestureMean()
    }
    
    
    func publishGestureOnGlobalServer(data:[Sample4D]) {
        Globals.log("Publishing gesture on global server...")
        let sample = GestureSample(timestamp: Utils.getCurrentMillis(), data: data)
        let gobj = GestureObj(uuid:self.gUUID, name:self.name, samples: [sample])
        GesturesUrlApi.sendGesturePOST(deviceId: Device.DEVICE_ID, gs: gobj){ result in
            switch result {
            case .success(let success):
                print("Gesture published with success: \(success)")
            case .failure(let error):
                print("Gesture publish error: \(error)")
            }
        }
    }

}

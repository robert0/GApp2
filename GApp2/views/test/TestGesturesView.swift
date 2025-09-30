//
//  TestGesturesView.swift
//  GApp2
//
//  Created by Robert Talianu
//


// TestGesturesView.swift
import SwiftUI

struct TestGesturesView: View {
    @StateObject private var subscriptionManager = HIDPeripheralSubscriptionManager.shared
    @ObservedObject private var wdConnector = WDConnector.shared
    @ObservedObject private var gRouter = RawGestureDeviceRouter.shared
    
    //next vars will be created only once
    private var analyser:RealtimeMultiGestureStoreAnalyser
    private static var dataRenderer: TestGesturesViewRenderer?
    private static var eventsHandler: AccelerometerEventStoreHandler?
    @State private var isStreaming: Bool = RawGestureDeviceRouter.shared.isStreaming
    @State private var showSettingsMenu = false
    var gesturesStore:MultiGestureStore
    
    init(_ analyser: RealtimeMultiGestureStoreAnalyser) {
        //the init will be called every time the user goes away from this page.(the parent has a reference to it, so it will be recreated)
        Globals.log("Testing gesture view, init() ...")
        //Create & link Gesture Analyser
        self.analyser = analyser
        self.gesturesStore = analyser.getGestureStore()
        
        if(TestGesturesView.dataRenderer == nil){
            initializeStatics();
        } else {
            cleanUp() //otherview do cleanup of static data
        }
    }

    //
    func initializeStatics(){
        //Create the view  and wire it
        TestGesturesView.dataRenderer = TestGesturesViewRenderer()
        TestGesturesView.dataRenderer!.setDataProvider(analyser)
        
        self.analyser.setChangeListener(TestGesturesView.dataRenderer)
        self.analyser.addEvaluationListener(TestGesturesView.dataRenderer)
        
        //connect to the data supplier
        Globals.logToScreen("Initializing Sensor Manager...")
        RawGestureDeviceRouter.addListener(analyser)

    }
    
    //used to clean view & cached data
    func cleanUp(){
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (!GApp2App.isMinimalViewActive){//disable ssh on minimal view
                    if SSHConnector.isActive() {
                        Text("Connected to SSH Server: \(GApp2App.getSshServerName()?.description ?? "Unknown")")
                            .italic()
                            .foregroundColor(.green)
                        Text("Info: Gestures commands will be streamed to the SSH server.")
                            .italic()
                            .foregroundColor(.green)
                    } else if GApp2App.getSshServerName() != nil {
                        Text("Warning: Not connected to SSH Server. Go to Settings menu to configure SSH connection or check if the SSH server is reachable.")
                            .foregroundColor(.gray)
                            .italic()
                            .font(.footnote)
                    }
                }
                
                if (!GApp2App.isMinimalViewActive){//disable ssh on minimal view
                    Spacer().frame(height: 30)
                    Text("Test gestures:").italic()
                } else {
                    HStack {
                        Spacer()
                        NavigationLink {
                            MinimalViewSettings( gesturesStore)
                        } label: {
                            Label("Settings", systemImage: "gearshape")
                        }
                        Spacer().frame(width: 20)
                    }
                 }
                
                Spacer().frame(height: 30)
                HStack {
                    Text("Available Gestures:").italic().foregroundColor(.black)
                    Text("\(analyser.getKeys()?.count ?? 0)")
                        .italic()
                        .foregroundColor(analyser.getKeys()?.count ?? 0 > 0 ? .green : .red)
                }
                HStack {
                    Text("Bluetooth HID Subscribers:").italic().foregroundColor(.black)
                    Text("\(subscriptionManager.getHidSubscribersCount())")
                        .italic()
                        .foregroundColor(subscriptionManager.getHidSubscribersCount() > 0 ? .green : .red)
                }
                HStack {
                    Text("Watch Connection: ").italic().foregroundColor(.black)
                    if(wdConnector.watchSessionValid) {
                        Text("YES")
                            .italic()
                            .foregroundColor(.green)
                    } else {
                        Text("NO")
                            .italic()
                            .foregroundColor(.red)
                    }
                }
                HStack {
                    Text("Data Source: ").italic().foregroundColor(.black)
                    if(gRouter.deviceType == DeviceType.Phone) {
                        Text("iPhone")
                            .italic()
                            .foregroundColor(.blue)
                    }  else if(gRouter.deviceType == DeviceType.Watch) {
                     
                        Text("iWatch")
                            .italic()
                            .foregroundColor(.blue)
                    } else {
                        Text("Not Set")
                            .italic()
                            .foregroundColor(.gray)
                    }
                }
                //add buttons
                HStack {
                    Spacer()
                    Button("Test") {
                        Globals.log("'Testing' clicked")
                        if(RawGestureDeviceRouter.shared.deviceType == nil){
                            RawGestureDeviceRouter.setSourceToThisPhone()
                        }
                        
                        RawGestureDeviceRouter.startStreaming()
                        self.analyser.startAnalysing()
                        isStreaming = true
                        
                    }
                    //.buttonStyle(isStreaming ? .plain : .borderedProminent)
                    .buttonStyle(.borderedProminent)
                    .disabled(isStreaming)
                    Spacer().frame(width: 10)
                    
                    Button("Stop Testing") {
                        Globals.log("'Stop Testing' clicked")
                        self.analyser.stopAnalysing()
                        RawGestureDeviceRouter.stopStreaming()
                        isStreaming = false
                        
                    }
                    //.buttonStyle(!isStreaming ? .bordered : .borderedProminent)
                    .buttonStyle(.borderedProminent)
                    .disabled(!isStreaming)
                    Spacer().frame(width: 10)
                    
                    Spacer()
                }
                
                //add data view panel
                TestGesturesView.dataRenderer
                
                // Add gesture data renderer or visualizer here
                Spacer()
            }
            .onAppear { isStreaming = RawGestureDeviceRouter.shared.isStreaming }
            .onDisappear {
                analyser.stopAnalysing()
                RawGestureDeviceRouter.stopStreaming()
                isStreaming = false
            }
        }
    }
}

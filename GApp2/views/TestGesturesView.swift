import CoreMotion
//
//  AppTabView.swift
//  GApp
//
//  Created by Robert Talianu
//
import SwiftUI

struct TestGesturesView: View {
    @Environment(\.dismiss) var dismiss
    
    //next vars will be created only once
    private var analyser:RealtimeMultiGestureStoreAnalyser
    private static var dataRenderer: TestingViewRenderer?
    private static var eventsHandler: AccelerometerEventStoreHandler?
    @State private var isStreaming: Bool = RawGestureDeviceRouter.shared.isStreaming
    
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
        RawGestureDeviceRouter.addListener(analyser)

    }
    
    //used to clean view & cached data
    func cleanUp(){
        
    }
    
    
    // The app panel
    var body: some View {
        return VStack {
            Spacer().frame(height: 10)
            if(SSHConnector.isActive()) {
                Text("Connected to SSH Server: \(GApp2App.getSshServerName()?.description ?? "Unknown")")
                    .italic()
                    .foregroundColor(.green)
                Text("Info: Gestures commands will be streamed to the SSH server.")
                    .italic()
                    .foregroundColor(.green)
            } else {
                if(GApp2App.getSshServerName() != nil) {
                    Text("Warning: Not connected to SSH Server. Go to Settings menu to configure SSH connection or check if the SSH server is reachable.")
                        .foregroundColor(.gray)
                        .italic()
                        .font(.footnote)
                }
            }
            
//            Text("Test commands via ssh:").italic()
//            HStack {
//                Button("Open") {
//                    openKeynotePressed()
//                }.padding(10)
//                
//                Button("< Previous") {
//                    previousPressed()
//                }.padding(10)
//                
//                Button("Next >") {
//                    nextPressed()
//                }.padding(10)
//                
//            }.padding(0)
            
            Spacer().frame(height: 30)
            Text("Test gestures:").italic()
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

            Spacer().frame(height: 10)
            Text("Test watch:").italic()
            
            Spacer().frame(height: 10)
            if(!GApp2App.isWatchConnectivityActive()){
                Text("Warning: Watch connection is not active! Check bluetooth, network or that app is also running on watch.")
                    .foregroundColor(.gray)
                    .italic()
                    .font(.footnote)
            }
            Spacer().frame(height: 10)
            HStack {
                Button("Send 3 Clicks") {
                    GApp2App.sendWatchAHapticMessage(HapticType.click3, ".click3")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!GApp2App.isWatchConnectivityActive())
                Spacer().frame(width: 10)
                
                Button("Send Notification") {
                    GApp2App.sendWatchAHapticMessage(HapticType.notification, ".notification")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!GApp2App.isWatchConnectivityActive())
                Spacer().frame(width: 10)
            }
            
            
            Spacer().frame(height: 10)
            Text("Test HID:").italic()
            
            Spacer().frame(height: 10)
            HStack {
                Button("Send KeyTyped") {
                    GApp2App.sendHIDKeyTyped(keyCodes: [0x04])
                }
                .buttonStyle(.borderedProminent)
                Spacer().frame(width: 10)
                
                Button("Send MouseMove") {
                    GApp2App.sendHIDMouseMove(dx: 10, dy: 10, buttons: 0)
                }
                .buttonStyle(.borderedProminent)
                Spacer().frame(width: 10)
            }
                
            
            //add data view panel
            TestGesturesView.dataRenderer
            Spacer()
            
        }
        .onAppear {
            isStreaming = RawGestureDeviceRouter.shared.isStreaming
        }
        .onDisappear {
            //force stop streaming
            self.analyser.stopAnalysing()
            RawGestureDeviceRouter.stopStreaming()
            //self.analyser.clear() - to be implemented
            isStreaming = false
        }
    }
    
    
    func openKeynotePressed() {
        print("open pressed")
        
        //mac
        var command = SSHCommands.startKeynoteApp_Play_cmd.rawValue
        var response: String? = GApp2App.executeCommandViaSSH(command)

        print(response ?? "No response")
    }
    
    func nextPressed() {
        print("next pressed")

        var command = "osascript -e 'tell application \"System Events\" to key code 121'"
        var response: String? = GApp2App.executeCommandViaSSH(command)
        
        print(response ?? "No response")
    }
    
    func previousPressed() {
        print("previous pressed")

        var command = "osascript -e 'tell application \"System Events\" to key code 116'"
        var response: String? = GApp2App.executeCommandViaSSH(command)
        
        print(response ?? "No response")
    }
}

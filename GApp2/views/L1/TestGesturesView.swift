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
        RawGestureDeviceRouter.addListener(analyser)

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
                    if(RawGestureDeviceRouter.shared.deviceType == nil){
                        RawGestureDeviceRouter.setSourceToThisPhone()
                    }
                    
                    RawGestureDeviceRouter.startStreaming()
                    self.analyser.startAnalysing()
                  
                }.buttonStyle(.borderedProminent)
                Spacer().frame(width: 10)
                
                Button("Stop Testing") {
                    Globals.log("Stop Testing Clicked !!!...")
                    self.analyser.stopAnalysing()
                    RawGestureDeviceRouter.stopStreaming()

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
                
                Button("Advertise") {
                    Globals.log("Advertise Message clicked...")
                    //GApp2App.sendWatchAMessage(".click3")
                    GApp2App.advertiseMessage("This is an advertised message!")

                }.buttonStyle(.borderedProminent)
                Spacer().frame(width: 10)

                
//                Button("POST Gesture") {
//                    Globals.log("POST Gesture clicked...")
//                    //GApp2App.sendWatchAMessage(".click3")
//                    let gobj = GestureObj(uuid:UUID().uuidString, name:"FirstG", samples: [])
//                    
//                    GesturesUrlApi.sendGesturePOST(deviceId: "iphone-1234ZXCV", gs: gobj){ result in
//                        switch result {
//                        case .success(let success):
//                            print("POST success: \(success)")
//                        case .failure(let error):
//                            print("POST error: \(error)")
//                        }
//                    }
//
//                }.buttonStyle(.borderedProminent)
//                Spacer().frame(width: 10)
                Spacer()
            }
            
            HStack {
                Button("Open") {
                    openKeynotePressed()
                }.padding(10)
                
                Button("Next >") {
                    nextPressed()
                }.padding(10)
                
                Button("< Previuos") {
                    previousPressed()
                }.padding(10)
            }
            
            //add data view panel
            TestGesturesView.dataRenderer
            
        }.onDisappear {
            //force stop streaming
            self.analyser.stopAnalysing()
            RawGestureDeviceRouter.stopStreaming()
            //self.analyser.clear() - to be implemented
        }
    }
    
    
    func openKeynotePressed() {
        print("open pressed")
        
        //mac
        var command = SSHCommands.startKeynoteApp_Play_cmd.rawValue
        var response: String? = SSHConnector.executeCommand(command)

        print(response ?? "No response")
    }
    
    func nextPressed() {
        print("next pressed")

        var command = "osascript -e 'tell application \"System Events\" to key code 121'"
        var response: String? = SSHConnector.executeCommand(command)
        
        print(response ?? "No response")
    }
    
    func previousPressed() {
        print("previous pressed")

        var command = "osascript -e 'tell application \"System Events\" to key code 116'"
        var response: String? = SSHConnector.executeCommand(command)
        
        print(response ?? "No response")
    }
}

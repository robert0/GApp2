import CoreMotion
//
//  EditGesturesView.swift
//  GApp2
//
//  Created by Robert Talianu
//
import SwiftUI

struct EditGestureView: View {
    @Environment(\.dismiss) var dismiss

    //special local props
    @ObservedObject var viewModel: EditGestureViewModel
    private let initialKey: String
    
    //local updatable values
    @State private var gkey: String
    @State private var selectedCmd: Command = Command.startKeynote
    @State private var selectedActionType: ActionType = ActionType.executeCommand
    @State private var threshold:Double = 0.5
    
    enum Command: String, CaseIterable, Identifiable {
        case startKeynote = """
                    if running of application \"Keynote\" is true then
                            tell application \"Keynote\"
                            activate
                            try
                                if playing is false then start the front document
                            end try
                        end tell
                    end if
                    """
        
        case keynoteNextSlide = """
                    if running of application \"Keynote\" is true then
                            tell application \"Keynote\"
                            activate
                            try
                                show next
                            end try
                        end tell
                    end if
                    """
        
        case keynotePreviusSlide = """
                    if running of application \"Keynote\" is true then
                            tell application \"Keynote\"
                            activate
                            try
                                show previous
                            end try
                        end tell
                    end if
                    """
        case openYahoo = """
                    if running of application \"Safari\" is true then
                            tell application \"Safari\"
                            activate
                            try
                                 open location \"https://www.google.com\"
                            end try
                        end tell
                    end if
                    """
        case openFacebook = """
                    if running of application \"Safari\" is true then
                            tell application \"Safari\"
                            activate
                            try
                                 open location \"https://www.facebook.com\"
                            end try
                        end tell
                    end if
                    """
        var id: Self { self }
    }
    
    // constructor
    init(_ gesturesStore: MultiGestureStore, _ gkey: String) {
        self.viewModel = EditGestureViewModel(gesturesStore)
        
        //Create & link Gesture Analyser
        self.initialKey = gkey
        self.gkey = gkey
        let gs = gesturesStore.getGesture(gkey)
        if(gs != nil){
            Globals.log("init initial cmd:\(gs!.getCommand())")
            self.selectedCmd = Command.allCases.filter{$0.rawValue == gs!.getCommand()}.first ?? Command.startKeynote
            self.selectedActionType = gs!.getActionType()
        }
    }
    
    
    // The app panel
    var body: some View {
        return VStack {
            //add buttons
            VStack (alignment: .leading){
                Spacer().frame(height: 50)
                Text("Edit Name:")
                    .font(.title3)
                TextField("Name", text: $gkey)
                    .padding(10)
                    .contentMargins(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                
                Spacer().frame(height: 20)
                
                Text("Do action when gesture match is above threshold:")
                    .font(.title3)
                TextField("Value", value: $threshold, format:.number)
                //.textFieldStyle(.plain)
                    .padding(10)
                    .contentMargins(10)
                    .onChange(of: threshold) { oldValue, newValue in
                        //TODO...
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                //.overlay(RoundedRectangle(cornerRadius: 5).stroke(isNameMissing ? Color.red : Color.gray))
                Spacer().frame(height: 20)
                
                Text("Select Action Type:")
                    .font(.title3)
                Picker("", selection: $selectedActionType) {
                    Text("Execute Command Locally").tag(ActionType.executeCommand)
                      Text("Forward Gesture/Command via Bluetooth").tag(ActionType.executeCmdViaBluetooth)
                }
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.orange)
                )
                Spacer().frame(height: 20)
                
                ///     @State private var myMoney: Double? = 300.0
                ///     var body: some View {
                ///         TextField(
                ///             "Currency (USD)",
                ///             value: $myMoney,
                ///             format: .currency(code: "USD")
                ///         )
                ///         .onChange(of: myMoney) { newValue in
                ///             print ("myMoney: \(newValue)")
                ///         }
                ///     }
                ///

                if(selectedActionType == ActionType.executeCommand || selectedActionType == ActionType.executeCmdViaBluetooth){
                    Text("Choose Command to execute:")
                        .font(.title3)
                    
                    Picker("Execute Command:", selection: $selectedCmd) {
                        Text("Start Keynote").tag(Command.startKeynote)
                        Text("Keynote - Go To Next Slide").tag(Command.keynoteNextSlide)
                        Text("Keynote - Go To Previuos Slide").tag(Command.keynotePreviusSlide)
                        Text("Open Yahoo Page").tag(Command.openYahoo)
                        Text("Open Facebook Page").tag(Command.openFacebook)
                    }
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                    if(selectedActionType == ActionType.executeCmdViaBluetooth){
                        Spacer().frame(height: 20)
                        Text("Info: Gestures data will be streamed to all connected Bluetooth devices.").italic()
                    }
//                    if(GApp2App.btPeripheralDevice == nil){
//                        NavigationLink {
//                            BTView()
//                        } label: {
//                            Label("Configure Bluetooth...", systemImage: "iphone.gen1.and.arrow.left")
//                        }.frame(width:250)
//                        
//                    } else {
//                        NavigationLink {
//                            BTView()
//                        } label: {
//                            Label("Paired to \(GApp2App.btPeripheralDevice?.name ?? "Unknown")", systemImage: "link")
//                        }.frame(width:250)
//                    }
                    
                }
                Spacer().frame(height: 50)
                
                
            }.padding(20)
            
            Spacer()
            Button("Update") {
                Globals.log("Update Edited")
                
                var gs = viewModel.gesturesStore.getGesture(initialKey)
                if(gs != nil){
                    //set/change all props
                    gs!.setCommand(selectedCmd.rawValue)
                    gs!.setActionType(selectedActionType)
                    gs!.setActionThreshold(threshold)
                    //Globals.log("cmd: \(gs!.getCommand())")
                    
                    //set/change key (&name)
                    //if(self.initialKey != gkey){
                    gs!.setName(gkey)
                    Globals.log("updating: \(gs!.getName())")
                    viewModel.gesturesStore.removeGesture(initialKey)
                    viewModel.gesturesStore.setGesture(gkey, gs)
                    //}
                }
                
                //return to previous view
                dismiss()
            }
            Spacer().frame(height: 20)
            
        }
        .onAppear {
            print("EditGestureView: onAppear...")
            //used for UI forced updates
            let gs = viewModel.gesturesStore.getGesture(gkey)
            if(gs != nil){
                self.selectedCmd = Command.allCases.filter{$0.rawValue == gs!.getCommand()}.first ?? Command.startKeynote
                self.selectedActionType = gs!.getActionType()
                self.threshold = gs!.getActionThreshold()
            } else {
                self.selectedCmd = Command.startKeynote
                self.selectedActionType = ActionType.executeCommand
            }
        }
    }
}


//
// Helper class for DataView that handles the updates
//
// Created by Robert Talianu
//
final class EditGestureViewModel: ObservableObject {
    @Published var gesturesStore: MultiGestureStore
    
    init(_ gesturesStore: MultiGestureStore) {
        self.gesturesStore = gesturesStore
    }
}



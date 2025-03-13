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
    @State private var selectedCmd: Command = Command.openGoogle
    @State private var selectedActionType: ActionType = ActionType.executeCommand
    
    
    enum Command: String, CaseIterable, Identifiable {
        case openGoogle = "open www.google.com"
        case openYahoo = "open www.yahoo.com"
        case openFacebook = "open www.facebook.com"
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
            self.selectedCmd = Command.allCases.filter{$0.rawValue == gs!.getCommand()}.first ?? Command.openGoogle
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
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                
                Spacer().frame(height: 20)
                
                Text("Select Gestures Action Type:")
                    .font(.title3)
                Picker("", selection: $selectedActionType) {
                    Text("Execute Command").tag(ActionType.executeCommand)
                    Text("Send via Bluetooth").tag(ActionType.forwardViaBluetooth)
                    Text("Execute Command and Forward via Bluetooth").tag(ActionType.executeCmdAndForwardViaBluetooth)
                }
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.orange)
                )
                Spacer().frame(height: 20)
                
                if(selectedActionType == ActionType.executeCommand || selectedActionType == ActionType.executeCmdAndForwardViaBluetooth){
                    Text("Choose Command to execute:")
                        .font(.title3)
                    
                    Picker("Execute Command:", selection: $selectedCmd) {
                        Text("Open Google Page").tag(Command.openGoogle)
                        Text("Open Yahoo Page").tag(Command.openYahoo)
                        Text("Open Facebook Page").tag(Command.openFacebook)
                    }
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                    if(selectedActionType == ActionType.executeCmdAndForwardViaBluetooth){
                        Spacer().frame(height: 20)
                        Text("Info: Gestures data will be streamed to all Bluetooth connected devices.").italic()
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
                    
                } else if(selectedActionType == ActionType.forwardViaBluetooth){
                    Spacer().frame(height: 20)
                    Text("Info: Gestures data will be streamed to all Bluetooth connected devices.").italic()
//                    if(GApp2App.btPeripheralDevice == nil){
//                        NavigationLink {
//                            BTView()
//                        } label: {
//                            Label("Choose BT device...", systemImage: "iphone.gen1.and.arrow.left")
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
                self.selectedCmd = Command.allCases.filter{$0.rawValue == gs!.getCommand()}.first ?? Command.openGoogle
                self.selectedActionType = gs!.getActionType()
            } else {
                self.selectedCmd = Command.openGoogle
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



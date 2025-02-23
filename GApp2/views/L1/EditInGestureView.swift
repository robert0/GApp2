import CoreMotion
//
//  EditGesturesView.swift
//  GApp2
//
//  Created by Robert Talianu
//
import SwiftUI

struct EditInGestureView: View {
    @Environment(\.dismiss) var dismiss

    //special local props
    @ObservedObject var viewModel: EditInGestureViewModel
    private let initialKey: String
    
    //local updatable values
    @State private var gkey: String
    @State private var gname: String
    @State private var selectedCmd: InCommand
    @State private var selectedActionType: GInActionType = GInActionType.executeCommand
    
    enum InCommand: String, CaseIterable, Identifiable {
        case openWebPage = "open www.google.com"
        case executeApp = "execute swiftUI"
        case runScript = "run cmd"
        var id: Self { self }
    }
    
    // constructor
    init(_ gesturesStore: InGestureStore, _ gmkey: String?) {
        Globals.log("--- init ---")
        self.viewModel = EditInGestureViewModel(gesturesStore)
        
        let gkey = ""
        if(gmkey == nil){
            //we are in create mode
            let gkey = "" // TODO...
            
        } else {
            let gkey = gmkey!
        }
        
        //Create & link Gesture Analyser
        self.initialKey = gkey
        self.gkey = gkey
        self.gname = ""
        let gs = gesturesStore.getGesture(gkey)
        if(gs != nil){
            Globals.log("init initial cmd:\(gs!.getCommand())")
            self.selectedCmd = InCommand.allCases.filter{$0.rawValue == gs!.getCommand()}.first ?? InCommand.openWebPage
            //Globals.log("init cmd:\( self.selectedCmd)")
        } else {
            self.selectedCmd = InCommand.openWebPage
        }
        //Globals.log("init cmd:\( self.selectedCmd)")
        
    }
    
    
    // The app panel
    var body: some View {
        return VStack {
            //add buttons
            VStack (alignment: .leading){
                Spacer().frame(height: 50)
                Text("Set Name:")
                    .font(.title3)
                TextField("Name", text: $gname)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                
                Spacer().frame(height: 20)
                
                Text("Map to incomming gesture Key:")
                    .font(.title3)
                TextField("MKey", text: $gkey)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                
                Spacer().frame(height: 20)
                
                Text("Select Action Type:")
                    .font(.title3)
                Picker("", selection: $selectedActionType) {
                    Text("Execute Command").tag(GInActionType.executeCommand)
                    Text("Forward to Watch").tag(GInActionType.forwardToWatch)
                    Text("Execute Command and Send to Watch").tag(GInActionType.executeCmdAndSendToWatch)
                }
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.orange)
                )
                Spacer().frame(height: 20)
                
                Text("Choose Command to execute:")
                    .font(.title3)               
                Picker("Execute Command:", selection: $selectedCmd) {
                    Text("Open Web Page").tag(InCommand.openWebPage)
                    Text("Execute App").tag(InCommand.executeApp)
                    Text("Run Script").tag(InCommand.runScript)
                }
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.orange)
                )
                
                
            }.padding(20)
            
            Spacer()
            Button("Update") {
                Globals.log("Update Edited")
                
                var gs = viewModel.gesturesStore.getGesture(initialKey)
                if(gs != nil){
//TODO...
//                    //set/change all props
//                    gs!.setCommand(selectedCmd.rawValue)
//                    Globals.log("cmd: \(gs!.getCommand())")
//                    
//                    //set/change key (&name)
//                    if(self.initialKey != gkey){
//                        gs!.setName(gname)
//                        gs!.setMappingName(gkey)
//                        Globals.log("name: \(gs!.getName())")
//                        viewModel.gesturesStore.removeGesture(initialKey)
//                        viewModel.gesturesStore.setGesture(gkey, gs)
//                    }
                    
                } else {
                    
                    //create mode
                    let gs = InGesture()
                    gs.setName(gname)
                    gs.setMappingName(gkey)
                    gs.setCommand(selectedCmd.rawValue)
                    gs.setGInActionType(selectedActionType)
                    //TODO .. set action
                    viewModel.gesturesStore.setGesture(gname, gs)
                }
                
                //return to previous view
                dismiss()
            }
            Spacer().frame(height: 20)
        }
    }
}


//
// Helper class for DataView that handles the updates
//
// Created by Robert Talianu
//
final class EditInGestureViewModel: ObservableObject {
    @Published var gesturesStore: InGestureStore
    
    init(_ gesturesStore: InGestureStore) {
        self.gesturesStore = gesturesStore
    }
}



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
    @State private var igmName: String
    @State private var igkey: String
    @State private var selectedCmd: InCommand
    @State private var selectedActionType: GInActionType = GInActionType.ExecuteCommand
    
    enum InCommand: String, CaseIterable, Identifiable {
        case openWebPage = "open www.google.com"
        case executeApp = "execute swiftUI"
        case runScript = "run cmd"
        var id: Self { self }
    }
    
    // constructor
    init(_ gesturesStore: InGestureStore, _ igmName: String?) {
        //Globals.log("--- init ---")
        self.viewModel = EditInGestureViewModel(gesturesStore)
        
        var igName = ""
        if(igmName == nil){
            //we are in create mode
            igName = "" // TODO...
        } else {
            igName = igmName!
        }
        
        //Create & link Gesture Analyser
        self.initialKey = igName
        let igmObj = gesturesStore.getGestureMapping(igName)
        if(igmObj != nil){ // edit page
            Globals.log("init initial cmd:\(igmObj!.getCommand())")
            self.igmName = igmObj!.getName()
            self.igkey = igmObj!.getIncommingGKey()
            self.selectedCmd = InCommand.allCases.filter{$0.rawValue == igmObj!.getCommand()}.first ?? InCommand.openWebPage
            self.selectedActionType = igmObj!.getIGActionType()
            //Globals.log("init cmd:\( self.selectedCmd)")
            
        } else {// create page
            self.igkey = ""
            self.igmName = ""
            self.selectedCmd = InCommand.openWebPage
            self.selectedActionType = GInActionType.ExecuteCommand
        }
        //Globals.log("init cmd:\( self.selectedCmd)")
    }
    
    
    // The app panel
    var body: some View {
        return VStack {
            //add buttons
            VStack (alignment: .leading){
                Spacer().frame(height: 30)
                Text("Set the gesture mapping")
                    .font(.title3)
                Spacer().frame(height: 30)
                
                Text("Name:")
                    .font(.title3)
                TextField("Name", text: $igmName)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                
                Spacer().frame(height: 20)
                
                Text("Key/Name (incomming gesture):")
                    .font(.title3)
                TextField("Key", text: $igkey)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                
                Spacer().frame(height: 20)
                
                Text("Select Action Type:")
                    .font(.title3)
                Picker("", selection: $selectedActionType) {
                    Text("Execute Command").tag(GInActionType.ExecuteCommand)
                    Text("Forward to Watch").tag(GInActionType.ForwardToWatch)
                    Text("Execute Command and Send to Watch").tag(GInActionType.ExecuteCmdAndSendToWatch)
                }
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.orange)
                )
                Spacer().frame(height: 20)
                
                if(selectedActionType == GInActionType.ExecuteCommand || selectedActionType == GInActionType.ExecuteCmdAndSendToWatch){
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
                }
                
            }.padding(20)
            
            Spacer()
            Button("Update") {
                Globals.log("Update clicked....")
                
                var gs = viewModel.gesturesStore.getGestureMapping(initialKey)
                if(gs != nil){
                    //set/change all props
                    gs!.setName(igmName)
                    gs!.setIncommingGKey(igkey)
                    gs!.setGInActionType(selectedActionType)
                    gs!.setCommand(selectedCmd.rawValue)
                    
                    //set/change key (&name)
                    //remove old ->  insert new
                    viewModel.gesturesStore.removeGestureMapping(initialKey)
                    viewModel.gesturesStore.setGestureMapping(igmName, gs)
                    
                    
                } else {
                    
                    //create mode
                    let gs = InGestureMapping()
                    gs.setName(igmName)
                    gs.setIncommingGKey(igkey)
                    gs.setGInActionType(selectedActionType)
                    gs.setCommand(selectedCmd.rawValue)
                    //save to store
                    viewModel.gesturesStore.setGestureMapping(igmName, gs)
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



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
    private var initialKey: String

    //local updatable values
    @State private var igmName: String
    @State private var igkey: String
    @State private var selectedCmd: InCommand
    @State private var selectedActionType: GInActionType = GInActionType.ExecuteCommand
    @State private var iwMessage: String = ""
    @State private var iwHaptic:HapticType = HapticType.none
    
    enum InCommand: String, CaseIterable, Identifiable {
        case openWebPage = "Open Web Page"
        case executeApp = "Run App"
        case runScript = "Run Script"
        
        //
        var id: Self { self }
        
        //
        func stringValue() -> String {
            return rawValue
        }
        
        //
        static func from(_ string: String) -> HapticType? {
            return HapticType(rawValue: string)
        }
    }
    
    // constructor
    init(_ igesturesStore: InGestureStore, _ igmKey: String?) {
        //Globals.log("--- init ---")
        self.viewModel = EditInGestureViewModel(igesturesStore)
        
        self.initialKey = ""
        if(igmKey == nil){
            //we are in create mode
            self.initialKey = "" // TODO...
        } else {
            self.initialKey = igmKey!
        }
        
        //Create & link Gesture Analyser
        let igmObj = igesturesStore.getGestureMapping(self.initialKey)
        if(igmObj != nil){ // edit page
            Globals.log("init initial cmd:\(igmObj!.getCommand())")
            self.igmName = igmObj!.getName()
            self.igkey = igmObj!.getIncommingGKey()
            self.selectedCmd = InCommand.allCases.filter{$0.rawValue == igmObj!.getCommand()}.first ?? InCommand.openWebPage
            self.selectedActionType = igmObj!.getIGActionType()
            self.iwMessage = igmObj!.getIWatchMessage()
            self.iwHaptic = igmObj!.getIWatchHaptic() ?? HapticType.none
            //Globals.log("init cmd:\( self.selectedCmd)")
            
        } else {// create page
            self.igkey = ""
            self.igmName = ""
            self.selectedCmd = InCommand.openWebPage
            self.selectedActionType = GInActionType.ExecuteCommand
            self.iwMessage = ""
            self.iwHaptic = HapticType.none
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
                    ForEach(GInActionType.allCases, id: \.self) { action in
                        let menuText = action.stringValue()
                        Text("\(menuText)")
                        .tag(action)
                      }
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
                    Picker("", selection: $selectedCmd) {
                        ForEach(InCommand.allCases, id: \.self) { action in
                            let menuText = action.stringValue()
                            Text("\(menuText)")
                            .tag(action)
                          }
                    }
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                }
                Spacer().frame(height: 20)
                
                if(selectedActionType == GInActionType.ExecuteCmdAndSendToWatch || selectedActionType == GInActionType.ForwardToWatch){
                    Text("Message to be displayed on iWatch:")
                        .font(.title3)
                    TextField("Message", text: $iwMessage)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.orange)
                        )
                    
                    Spacer().frame(height: 20)
                    
                    Text("Haptic to be played by iWatch:")
                        .font(.title3)
                    Picker("", selection: $iwHaptic) {
                        ForEach(HapticType.allCases, id: \.self) { action in
                            let menuText = action.stringValue()
                            Text("\(menuText)")
                            .tag(action)
                          }
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
                
                var gs = viewModel.igesturesStore.getGestureMapping(initialKey)
                if(gs != nil){
                    //set/change all props
                    gs!.setName(igmName)
                    gs!.setIncommingGKey(igkey)
                    gs!.setGInActionType(selectedActionType)
                    gs!.setCommand(selectedCmd.rawValue)
                    gs!.setIWatchMessage(iwMessage)
                    gs!.setIWatchHaptic(iwHaptic)
                    
                    if(selectedActionType == GInActionType.ForwardToWatch){
                        gs!.setCommand(InCommand.openWebPage.rawValue) // reset command to default
                        
                    } else if(selectedActionType == GInActionType.ExecuteCommand){
                        gs!.setIWatchMessage("") // reset message
                        gs!.setIWatchHaptic(HapticType.none) // reset haptic
                    }
                    
                    //set/change key (&name)
                    //remove old ->  insert new
                    viewModel.igesturesStore.removeGestureMapping(initialKey)
                    viewModel.igesturesStore.setGestureMapping(igkey, gs)
                    
                    
                } else {
                    
                    //create mode
                    let gs = InGestureMapping()
                    gs.setName(igmName)
                    gs.setIncommingGKey(igkey)
                    gs.setGInActionType(selectedActionType)
                    gs.setCommand(selectedCmd.rawValue)
                    gs.setIWatchMessage(iwMessage)
                    gs.setIWatchHaptic(iwHaptic)
                    
                    if(selectedActionType == GInActionType.ForwardToWatch){
                        gs.setCommand(InCommand.openWebPage.rawValue) // reset command to default
                        
                    } else if(selectedActionType == GInActionType.ExecuteCommand){
                        gs.setIWatchMessage("") // reset message
                        gs.setIWatchHaptic(HapticType.none) // reset haptic
                    }
                    
                    //save to store
                    viewModel.igesturesStore.setGestureMapping(igkey, gs)
                        
                }
                
                //return to previous view
                dismiss()
            }
            Spacer().frame(height: 20)
            
        }.onAppear(){
            print("EditInGestureView: onAppear...")

            let igmObj = viewModel.igesturesStore.getGestureMapping(self.igkey)
            if(igmObj != nil){ // edit page
                self.igmName = igmObj!.getName()
                self.selectedCmd = InCommand.allCases.filter{$0.rawValue == igmObj!.getCommand()}.first ?? InCommand.openWebPage
                self.selectedActionType = igmObj!.getIGActionType()
                self.iwMessage = igmObj!.getIWatchMessage()
                self.iwHaptic = igmObj!.getIWatchHaptic() ?? HapticType.none
                //Globals.log("init cmd:\( self.selectedCmd)")
                
            } else {// create page
                self.igkey = ""
                self.igmName = ""
                self.selectedCmd = InCommand.openWebPage
                self.selectedActionType = GInActionType.ExecuteCommand
                self.iwMessage = ""
                self.iwHaptic = HapticType.none
            }
        }
    }
}


//
// Helper class for DataView that handles the updates
//
// Created by Robert Talianu
//
final class EditInGestureViewModel: ObservableObject {
    @Published var igesturesStore: InGestureStore
    
    init(_ gesturesStore: InGestureStore) {
        self.igesturesStore = gesturesStore
    }
}



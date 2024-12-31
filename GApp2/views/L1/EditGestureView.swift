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
    @State private var selectedCmd: Command

    enum Command: String, CaseIterable, Identifiable {
        case openGoogle = "open www.google.com"
        case openYahoo = "open www.yahoo.com"
        case openFacebook = "open www.facebook.com"
        var id: Self { self }
    }
    
    // constructor
    init(_ analyser: RealtimeMultiGestureStoreAnalyser, _ gkey: String) {
        Globals.log("--- init ---")
        self.viewModel = EditGestureViewModel(analyser: analyser)
       
        
        //Create & link Gesture Analyser
        self.initialKey = gkey
        self.gkey = gkey
        let gs = analyser.getGesture(gkey)
        if(gs != nil){
            Globals.log("init initial cmd:\(gs!.getCommand())")
            self.selectedCmd = Command.allCases.filter{$0.rawValue == gs!.getCommand()}.first ?? Command.openGoogle
            Globals.log("init cmd:\( self.selectedCmd)")
        } else {
            self.selectedCmd = Command.openGoogle
        }
        Globals.log("init cmd:\( self.selectedCmd)")
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
                
                Text("Execute Command:")
                    .font(.title3)
                //                TextField("Command", text: $command)
                //                    .padding(5)
                //                    .overlay(
                //                        RoundedRectangle(cornerRadius: 5)
                //                            .stroke(Color.orange)
                //                    )
                
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
                

            }.padding(20)
            
            Spacer()
            Button("Save") {
                Globals.log("Save Edited")
                
                var gs = viewModel.analyser.getGesture(initialKey)
                if(gs != nil){
                    //set/change all props
                    gs!.setCommand(selectedCmd.rawValue)
                    Globals.log("cmd: \(gs!.getCommand())")
                    
                    //set/change key (&name)
                    if(self.initialKey != gkey){
                        gs!.setName(gkey)
                        Globals.log("name: \(gs!.getName())")
                        viewModel.analyser.removeGesture(initialKey)
                        viewModel.analyser.setGesture(gkey, gs)
                    }
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
final class EditGestureViewModel: ObservableObject {
    @Published var analyser: RealtimeMultiGestureStoreAnalyser
    
    init(analyser: RealtimeMultiGestureStoreAnalyser) {
        self.analyser = analyser
    }
}



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
    @State private var selectedCmd: String = ScriptCmd.macOs_startKeynoteApp_Play.rawValue
    @State private var selectedActionType: ActionType = ActionType.executeCommand
    @State private var threshold:Double = 0.5
    @State private var customCmd:String = ""
    @State private var isCmdMissing: Bool = true
    
    @State private var selectedIndex = 0
    
    var selectedKey: KeyboardKey {
        KeyboardKeysMapping[selectedIndex]
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
            
            //check the command is in the ScriptCmd enumeration
            var isKnownCmd = ScriptCmd.allCases.filter{$0.rawValue == gs!.getCommand()}.first
            if(isKnownCmd == nil){
                //if not, set it to custom command
                isKnownCmd = ScriptCmd.customCmd
                self.selectedCmd =  ScriptCmd.customCmd.rawValue
                self.customCmd = gs!.getCommand()
                
            } else {
                self.selectedCmd = gs!.getCommand()
            }

            self.selectedActionType = gs!.getActionType()
            if(gs?.getHIDCommand() != nil && gs!.getHIDCommand() != ""){
                let hidParts = gs!.getHIDCommand().split(separator: Device.HID_Modifiers_Keycode_Separator)
                let keyCode = Int(hidParts[1])!
                //let modifiers = hidParts[0]
                self.selectedIndex = KeyboardKeysMapping.firstIndex(where: { $0.keyCode == keyCode }) ?? 0
            }
        }
    }
    
    
    
    // The app panel
    var body: some View {
        return VStack {
            //add buttons
            VStack (alignment: .leading){
                Spacer().frame(height: 50)
                Text("Gesture Name(Key):")
                TextField("Name", text: $gkey)
                    .padding(10)
                    .contentMargins(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                
                Spacer().frame(height: 20)
                
                Text("Do action when gesture match is above threshold:")
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
                Picker("", selection: $selectedActionType) {
                    ForEach(ActionType.allCases, id: \.self) { action in
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
                
                if(selectedActionType == ActionType.executeCommand ||
                   selectedActionType == ActionType.executeCmdViaBluetooth ||
                   selectedActionType == ActionType.executeCmdViaSSH
                ){
                    Text("Choose Command to execute:")
                    //picker over an enumeration
                    Picker("Execute Command:", selection: $selectedCmd) {
                        ForEach(ScriptCmd.allCases, id: \.self) { cmd in
                            let menuText = cmd.stringValue()
                            Text("\(menuText)").tag(cmd.rawValue)
                          }
                    }
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                    Spacer().frame(height: 20)
                    
                    // Custom command
                    if(selectedCmd ==  ScriptCmd.customCmd.rawValue){
                        Text("Set the Command to execute:")
                        TextField("Command", text: $customCmd)
                            .textFieldStyle(.plain)
                            .padding(10)
                            .contentMargins(10)
                            .onChange(of: customCmd) { _ in
                                isCmdMissing = customCmd.isEmpty
                            }
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(isCmdMissing ? Color.red : Color.gray))
                        Spacer().frame(height: 20)
                    }
                    
                    //Warning for ssh connection
                    if(selectedActionType == ActionType.executeCmdViaSSH){
                        if(SSHConnector.isActive()){
                            Text("Connected to SSH Server: \(GApp2App.getSshServerName()?.description ?? "Unknown")")
                                .foregroundColor(.green)
                            Text("Info: Gestures commands will be streamed to the SSH server.")
                                .italic()
                                .foregroundColor(.green)
                        } else {
                            Text("Not connected to SSH Server. Go to Settings menu to configure SSH connection or check if the SSH server is reachable.")
                                .foregroundColor(.red)
                        }
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
                    
                } else if(selectedActionType == ActionType.executeAsHID){
                    //VStack(alignment: .trailing) {
                        Text("Select the Key:")
                        Picker("Select Key", selection: $selectedIndex) {
                            ForEach(KeyboardKeysMapping.indices, id: \.self) { idx in
                                Text(KeyboardKeysMapping[idx].name)
                            }
                        }
                        //.pickerStyle(WheelPickerStyle())
                        .padding(5)
                        //.frame(minWidth: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.orange)
                        )
                        

                    HStack {
                        Text("Key Code: \(selectedKey.keyCode)").italic().foregroundColor(.gray)
                        Text("Modifier: \(selectedKey.modifier)").italic().foregroundColor(.gray)
                    }
                    //}
                }
                    
                Spacer().frame(height: 20)
                
            }.padding(20)
            
            Spacer()
            Button("Update") {
                Globals.log("Update Edited")
                
                var gs = viewModel.gesturesStore.getGesture(initialKey)
                if(gs != nil){
                    //set/change all props
                    gs!.setActionType(selectedActionType)
                    gs!.setActionThreshold(threshold)
                    gs!.setHIDCommand("\(selectedKey.modifier)\(Device.HID_Modifiers_Keycode_Separator)\(selectedKey.keyCode)")
                    if(selectedCmd == ScriptCmd.customCmd.rawValue){
                        gs!.setCommand(customCmd)
                    } else {
                        gs!.setCommand(selectedCmd)
                    }
                    
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
                //check the command is in the ScriptCmd enumeration
                var isKnownCmd = ScriptCmd.allCases.filter{$0.rawValue == gs!.getCommand()}.first
                if(isKnownCmd == nil){
                    //if not, set it to custom command
                    isKnownCmd = ScriptCmd.customCmd
                    self.selectedCmd =  ScriptCmd.customCmd.rawValue
                    self.customCmd = gs!.getCommand()
                    
                } else {
                    self.selectedCmd = gs!.getCommand()
                }
                self.selectedActionType = gs!.getActionType()
                self.threshold = gs!.getActionThreshold()
                
                if(gs?.getHIDCommand() != nil && gs!.getHIDCommand() != ""){
                    let hidParts = gs!.getHIDCommand().split(separator: Device.HID_Modifiers_Keycode_Separator)
                    let keyCode = Int(hidParts[1])!
                    //let modifiers = hidParts[0]
                    self.selectedIndex = KeyboardKeysMapping.firstIndex(where: { $0.keyCode == keyCode }) ?? 0
                }
                
            } else {
                self.selectedCmd = ScriptCmd.allCases.first?.rawValue ?? ""
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



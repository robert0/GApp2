import CoreMotion
//
//  ManageGesturesView.swift
//  GApp2
//
//  Created by Robert Talianu
//
import SwiftUI

struct ManageGesturesView: View {
    @Environment(\.dismiss) var dismiss
    
    var gesturesStore:MultiGestureStore
    @State var counter:Int = 0
    @State var showConfirmation:Bool = false
    @State var deletingKey:String = ""
    @State private var selectedActionType: ActionType = ActionType.executeCommand
    

    
    // constructor
    init( _ gesturesStore: MultiGestureStore) {
        self.gesturesStore = gesturesStore
        self.selectedActionType = GApp2App.getGestureActionType()
    }
        
    // The app panel
    var body: some View {
        return VStack {
            
            Text("Select Gestures Action Type:")
                .font(.title3)
            Picker("", selection: $selectedActionType) {
                Text("Execute Command").tag(ActionType.executeCommand)
                Text("Send via Bluetooth").tag(ActionType.forwardViaBluetooth)
            }
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.orange)
            ).onChange(of: selectedActionType){
                print("on change called!")
                GApp2App.setGestureActionType(selectedActionType)
            }
            Spacer().frame(height: 20)
            
            if(selectedActionType == ActionType.forwardViaBluetooth){
                
                if(GApp2App.btPeripheralDevice == nil){
                    NavigationLink {
                        BTView()
                    } label: {
                        Label("Choose BT device...", systemImage: "iphone.gen1.and.arrow.left")
                    }.frame(width:250)
                    
                } else {
                    NavigationLink {
                        BTView()
                    } label: {
                        Label("Paired to \(GApp2App.btPeripheralDevice?.name ?? "Unknown")", systemImage: "link")
                    }.frame(width:250)
                }
            }
            Spacer().frame(height: 50)
            
            Text("Available Gestures:")
                .font(.title3)
            HStack {
                //create reqired data structure to be used by list
                List(listItems()) {widget in
                    HStack {
                        Text(String(counter)).frame(width:0)//used for UI forced updates
                        Text(widget.key)
                        Spacer()
                        
                        Button {
                            Globals.log("Delete button was tapped")
                            showConfirmation = true
                            deletingKey = widget.key
                            
                            
                        } label: {
                            Image(systemName: "trash")
                                .imageScale(.large)
                        }
                        .buttonStyle(.plain)
                        
                        Spacer().frame(width:30)
                        
                        NavigationLink(destination: EditGestureView(gesturesStore, widget.key)) {
                            Image(systemName: "pencil")
                                .imageScale(.large)
                        }.frame(width:50)
                        
                    }.confirmationDialog("Delete item \(deletingKey)?", isPresented: $showConfirmation) {
                        Button("Yes, delete", action: {
                            deleteGesture(deletingKey)
                        })
                    }
                }
                Spacer()
            }
            Spacer().frame(height: 20)
            
            Button("Save Gestures to Filesystem") {
                Globals.log("Save Gestures Clicked !!!...")
                FileSystem.writeLocalGesturesDataFile(self.gesturesStore.getRecordingData().getAllGestures())
                dismiss()
                
            }.buttonStyle(.borderedProminent)
            Spacer()
            
              
        }.onAppear {
            print("ManageGesturesView: onAppear...")
            self.selectedActionType = GApp2App.getGestureActionType()
            //used for UI forced updates
            counter = counter + 1
        }
    }
    
    func listItems() -> [ListWidget] {
        let widgets:[ListWidget] = gesturesStore.getKeys()!.map {
            return ListWidget($0)
        }
        return widgets
    }
    
    
    func deleteGesture(_ key:String){
        gesturesStore.deleteGesture(key)
        //force UI update
        counter = counter + 1
    }
}


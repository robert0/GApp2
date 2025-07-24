import CoreMotion
//
//  ManageGesturesView.swift
//  GApp2
//
//  Created by Robert Talianu
//
import SwiftUI

struct IncommingGesturesView: View {
    @Environment(\.dismiss) var dismiss
    
    var igesturesStore:InGestureStore
    @State var counter:Int = 0
    @State var showConfirmation:Bool = false
    @State var deletingKey:String = ""
    @State var isBTListening:Bool = false
    
    // constructor
    init( _ gesturesStore: InGestureStore) {
        self.igesturesStore = gesturesStore
    }
        
    // The app panel
    var body: some View {
        return VStack {
            Spacer().frame(height: 30)
            
            if(GApp2App.btPeripheralDevice == nil){
                Text("Bluetooth source device not configured")
                NavigationLink {
                    BTView()
                } label: {
                    Label("Configure Bluetooth...", systemImage: "iphone.gen1.and.arrow.left")
                }.frame(width:250)
                
            } else {
                NavigationLink {
                    BTView()
                } label: {
                    Label("Paired to \(GApp2App.btPeripheralDevice?.name ?? "Unknown")", systemImage: "link")
                }.frame(width:250)
            }
            
//            if(isBTListening == false){
//                
//                Button("Enable Bluetooth Listening") {
//                    Globals.log("Enable Bluetooth Listening Clicked !!!...")
//                    isBTListening = true
//                    //GApp2App.enableBTListening()
//                }.toggleStyle(SwitchToggleStyle())
//                .buttonStyle(.borderedProminent)
//                
//            } else {
//                Text("Bluetooth Listening is Enabled.")
//                Button("Disble Bluetooth Listening") {
//                    Globals.log("Enable Bluetooth Listening Clicked !!!...")
//                    isBTListening = false
//                    
//                }.toggleStyle(SwitchToggleStyle())
//                .buttonStyle(.borderedProminent)
//            }

            Spacer().frame(height: 30)
            
            NavigationLink {
                EditInGestureView(igesturesStore, nil)
            } label: {
                Label("Create new gesture mapping", systemImage: "plus.circle")
            }.frame(width:250).buttonStyle(.borderedProminent)
            Spacer().frame(height: 30)
            
           
            Text("Available Gesture Mappings:")
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
                        
                        NavigationLink(destination: EditInGestureView(igesturesStore, widget.key)) {
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
            
            Button("Save Gesture Mapping to Filesystem") {
                Globals.log("Save InGestures Clicked !!!...")
                FileSystem.writeIncommingGesturesMappingsDataFile(self.igesturesStore.getAllGestures())
                dismiss()
                
            }.buttonStyle(.borderedProminent)
            Spacer()
            
              
        }.onAppear {
            print("IncommingGesturesView: onAppear...")
            //used for UI forced updates
            counter = counter + 1
        }
    }
    
    func listItems() -> [ListWidget] {
        let widgets:[ListWidget] = igesturesStore.getKeys().map {
            return ListWidget($0)
        }
        return widgets
    }
    
    
    func deleteGesture(_ key:String){
        igesturesStore.deleteGestureMapping(key)
        //force UI update
        counter = counter + 1
    }
}


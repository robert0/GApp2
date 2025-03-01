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
    
    var gesturesStore:InGestureStore
    @State var counter:Int = 0
    @State var showConfirmation:Bool = false
    @State var deletingKey:String = ""

    
    // constructor
    init( _ gesturesStore: InGestureStore) {
        self.gesturesStore = gesturesStore
    }
        
    // The app panel
    var body: some View {
        return VStack {
                        
            Spacer().frame(height: 30)
            NavigationLink {
                EditInGestureView(gesturesStore, nil)
            } label: {
                Label("Create new gesture mapping", systemImage: "plus.circle")
            }.frame(width:250)
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
                        
                        NavigationLink(destination: EditInGestureView(gesturesStore, widget.key)) {
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
                FileSystem.writeIncommingGesturesMappingsDataFile(self.gesturesStore.getAllGestures())
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
        let widgets:[ListWidget] = gesturesStore.getKeys().map {
            return ListWidget($0)
        }
        return widgets
    }
    
    
    func deleteGesture(_ key:String){
        gesturesStore.deleteGestureMapping(key)
        //force UI update
        counter = counter + 1
    }
}


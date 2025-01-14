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
    
    // constructor
    init( _ gesturesStore: MultiGestureStore) {
        self.gesturesStore = gesturesStore
    }
        
    // The app panel
    var body: some View {
        return VStack {
            //add buttons
            HStack {
                Spacer()
                
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

//identifiable item to be used inside list
struct ListWidget: Identifiable {
    public let id = UUID()
    public var key: String
    
    init(_ key:String){
        self.key = key
    }
}



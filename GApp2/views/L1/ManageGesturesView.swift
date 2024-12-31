import CoreMotion
//
//  ManageGesturesView.swift
//  GApp2
//
//  Created by Robert Talianu
//
import SwiftUI

struct ManageGesturesView: View {
    var gesturesStoreAnalyser:RealtimeMultiGestureStoreAnalyser
    @State var counter:Int = 0
    
    // constructor
    init( _ gesturesStoreAnalyser: RealtimeMultiGestureStoreAnalyser) {
        self.gesturesStoreAnalyser = gesturesStoreAnalyser
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
                        } label: {
                            Image(systemName: "trash")
                                .imageScale(.large)
                        }.buttonStyle(.plain)
                        Spacer().frame(width:30)
                        
                        NavigationLink(destination: EditGestureView(gesturesStoreAnalyser, widget.key)) {
                            Image(systemName: "pencil")
                                .imageScale(.large)
                        }.frame(width:50)
                    }
                }
                Spacer()
            }

        }.onAppear {
            //used for UI forced updates
            counter = counter + 1
        }
    }
    
    func listItems() -> [ListWidget] {
        let widgets:[ListWidget] = gesturesStoreAnalyser.getKeys()!.map {
            return ListWidget($0)
        }
        return widgets
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



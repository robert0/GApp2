//
//  MainViewMenu.swift
//  GApp2
//
//  Created by Robert Talianu
//
import SwiftUI

struct MinimalViewSettings: View {
    @Environment(\.dismiss) private var dismiss
    var gesturesStore:MultiGestureStore
    @State var gCount:Int = 0
    
    init(_ gesturesStore:MultiGestureStore) {
        self.gesturesStore = gesturesStore
    }
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                Spacer()
                NavigationLink(destination: HIDSettings()) {
                    Image(systemName: "radiowaves.left")
                        .imageScale(.large)
                    Text("HID Settings")
                }
                Spacer().frame(height:30)
                NavigationLink(destination: ChooseSourceView()) {
                    Image(systemName: "applewatch.radiowaves.left.and.right")
                        .imageScale(.large)
                    Text("Choose Source")
                }
                Spacer().frame(height:30)
                NavigationLink(destination: CreateGestureView(gesturesStore)) {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                    Text("Create Gesture")
                }
                Spacer().frame(height:30)
                NavigationLink(destination: ManageGesturesView(gesturesStore)) {
                    Image(systemName: "pencil")
                        .imageScale(.large)
                    Text("Manage Gestures ( \(gCount) )")
                }
                Spacer()
             }
            .onAppear {
                gCount = gesturesStore.getKeys()?.count ?? 0
            }
        }
//        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: { dismiss() }) {
//                    Label("Main View", systemImage: "chevron.left")
//                }
//            }
//        }
    }
}

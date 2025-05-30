import CoreMotion
//
//  Settings.swift
//  GApp2
//
//  Created by Robert Talianu
//
import SwiftUI
import Foundation
import WatchConnectivity
import SwiftUICore

struct Settings: View {
    @Environment(\.dismiss) var dismiss
    let session = WCSession.default
    
    var gesturesStore:MultiGestureStore
    @State var counter:Int = 0
    
    @State private var gkey: String = ""
    @State private var user: String = ""
    @State private var password: String = ""
    
    
    // constructor
    init( _ gesturesStore: MultiGestureStore) {
        self.gesturesStore = gesturesStore
        
        //load the SSH data bean
        let sshDataBean = GApp2App.getSshDataBean()
        gkey = sshDataBean?.hostname ?? ""
        user = sshDataBean?.username ?? ""
        password = sshDataBean?.password ?? ""
    }
        
    // The app panel
    var body: some View {
        return VStack (alignment: .leading){
            
            VStack (alignment: .leading){
                Spacer().frame(height: 50)
                Text("Setup the credentials for SSH connection").italic()
                Spacer().frame(height: 10)
                Text("SSH IP Adress:")
                TextField("IP", text: $gkey)
                    .padding(10)
                    .contentMargins(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                
                Spacer().frame(height: 20)
                
                Text("Username:")
                TextField("Username", text: $user)
                //.textFieldStyle(.plain)
                    .padding(10)
                    .contentMargins(10)
                    .onChange(of: user) { oldValue, newValue in
                        //TODO...
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                //.overlay(RoundedRectangle(cornerRadius: 5).stroke(isNameMissing ? Color.red : Color.gray))
                Spacer().frame(height: 20)
                
                Text("Password:")
                SecureField("Password", text: $password)
                //.textFieldStyle(.plain)
                    .padding(10)
                    .contentMargins(10)
                    .onChange(of: user) { oldValue, newValue in
                        //TODO...
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.orange)
                    )
                //.overlay(RoundedRectangle(cornerRadius: 5).stroke(isNameMissing ? Color.red : Color.gray))
                Spacer().frame(height: 20)
                
                Spacer()
                HStack {
                    Spacer()
                    Button("Update") {
                        Globals.log("Update Edited")
                        
                        GApp2App.setSshDataBean(gkey, user, password)
                        
                        //save to filesystem
                        FileSystem.writeLocalSshDataBeanFile(GApp2App.getSshDataBean()!)
                        
                        //return to previous view
                        dismiss()
                    }.buttonStyle(.borderedProminent)
                    Spacer()
                }
            }.padding(20)
             
        }.onAppear {
            //used for UI forced updates
            counter = counter + 1
            
            //update the SSH data bean with the latest values
            let sshDataBean = GApp2App.getSshDataBean()
            gkey = sshDataBean?.hostname ?? ""
            user = sshDataBean?.username ?? ""
            password = sshDataBean?.password ?? ""
        }
    }

}




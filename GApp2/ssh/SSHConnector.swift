//
//  ContentView.swift
//  Ssh_cli2
//
//  Created by Robert Talianu
//

import SwiftUI
import NMSSH

class SSHConnector {
    static let shared = SSHConnector()//self intialization
    static var sshDataBean: SshDataBean?
    static var ssh_session: NMSSHSession?
    
    private init(){
        //        if(SSHConnector.ssh_session == nil){
        //            SSHConnector.authenticate()
        //        }
    }
    
    ///
    public static func initialize( sshDataBean: SshDataBean){
        if(SSHConnector.ssh_session != nil && ((SSHConnector.ssh_session?.isConnected) != nil)){
            disconnect()
        }
        SSHConnector.sshDataBean = sshDataBean
        //authenticate()
    }
    
    public static func authenticate() {
        // This function is not needed since we authenticate in the init
        let port:Int = 22
        
        //windows
        //        let hostname: String = "192.168.1.110"
        //        let username:String = "dev"
        //        let password:String = "sshpass"
        
        //mac
        //        let hostname: String = "192.168.1.104"
        //        let username:String = "roberttalianu"
        //        let password:String = "alpha"
        
        if(self.sshDataBean == nil || sshDataBean?.hostname == nil){
            print("Error: SSH Server credentials are not configured!")
            return
        }
        
        let hostname = sshDataBean?.hostname ?? ""
        let username = sshDataBean?.username ?? ""
        let password = sshDataBean?.password ?? ""
        
        ssh_session = NMSSHSession(host: hostname, andUsername: username)
        if ssh_session == nil {
            print("ERROR: Failed to create NMSSHSession")
            return
        }
        
        let variables:[NSString:NSString] = [
            "LANGUAGE":"en",
        ]
        
        ssh_session!.connect(withTimeout: 10)
        ssh_session!.channel.environmentVariables = variables
        if (ssh_session!.isConnected == false) {
            // error, stops here
            print("SSH connection failed")
            print("Error: \(ssh_session!.lastError )")
            return
        }
        
        ssh_session!.authenticate(byPassword:password)
        if (ssh_session!.isAuthorized == false) {
            // error, stops here
            print("Authentication failed!")
            print("Error: \(ssh_session!.lastError )")
            return
        }
        print("SSH connection succeeded. Waiting for commands...")
        
    }
       
    /// Disconnects the SSH session.
    public static func disconnect() {
        if let session = ssh_session {
            session.disconnect()
            print("SSH session disconnected.")
        } else {
            print("No SSH session to disconnect.")
        }
    }
    
    
    /// Checks if the SSH session is active.
    public static func isActive() -> Bool {
        return ssh_session != nil && ssh_session!.isConnected == true && ssh_session!.isAuthorized == true
    }
    
    
    /// Executes a command on the SSH server.
    public static func executeCommand(_ command: String) -> String? {
        //if we have lost connection, try a reconect
        if( ssh_session == nil || ssh_session!.isConnected == false || ssh_session!.isAuthorized == false ){
            print("Session is not connected or authorized")
            authenticate()
        }
            
        guard let session = ssh_session, session.isConnected, session.isAuthorized else {
            print("Error: Session could not be restored!")
            return "Not connected"
        }
        
        var response: String? =  session.channel.execute(command, error: nil)
        print(response ?? "No response")
        
        return response
    }
    
    
//    func readSFTPFile() {
//       
//
//        let session = NMSSHSession(host: host, port: port, andUsername: user)
//        session.connect()
//
//        if session.isConnected {
//            
//            session.authenticate(byPassword: password)
//
//            if session.isAuthorized {
//                let sftp = NMSFTP.connect(with: session)
//
//                if sftp != nil {
//                    let remotePath = fileToDownload
//                    let localPath = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Downloads/\(fileToDownload)")
//
//                    let fileData = sftp.contents(atPath: fileToDownload)
//                    let StrValue = String(data: fileData!, encoding: String.Encoding.utf8)
//                    print(StrValue)
//                    
//                    sftp.disconnect()
//                } else {
//                    print("Error connecting to SFTP server.")
//                }
//            } else {
//                print("Authentication failed.")
//            }
//            session.disconnect()
//        } else {
//            print("Connection failed.")
//        }
//    }
}


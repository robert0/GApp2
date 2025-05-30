//
//  SshDataBean.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

public class SshDataBean: Codable {
    // let hostname: String = "192.168.1.110"
    // let username:String = "dev"
    // let password:String = "sshpass"
    var hostname: String = ""
    var username: String = ""
    var password: String = ""
    
    public enum ConfigKeys: String, CodingKey {
        case hostname
        case username
        case password
    }
    
    
    init(){
        // nothing
    }
    
    
    /**
     * @param decoder
     */
    public required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.hostname = try values.decodeIfPresent(String.self, forKey: ConfigKeys.hostname)!
        self.username = try values.decodeIfPresent(String.self, forKey: ConfigKeys.username)!
        self.password = try values.decodeIfPresent(String.self, forKey: .password)!
    }
    
    /**
     * JSON encoder
     * @param encoder
     */
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: ConfigKeys.self)
       
        try container.encode(hostname, forKey: ConfigKeys.hostname)
        try container.encode(username, forKey: ConfigKeys.username)
        try container.encode(password, forKey: ConfigKeys.password)
    }
        
}

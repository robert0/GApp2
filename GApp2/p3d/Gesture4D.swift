//
//  Gesture4D.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

public class Gesture4D: Codable {
    private var data:[Sample4D] = []
    private var cmd:String = ""
    private var name:String = ""
    
    public enum ConfigKeys: String, CodingKey {
        case data
        case cmd
        case name
    }
        
    public init(){
        //empty constructor
    }
    
    /**
     * @param decoder
     */
    public required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.cmd = try values.decodeIfPresent(String.self, forKey: .cmd)!
        self.name = try values.decodeIfPresent(String.self, forKey: .name)!
        self.data = try values.decodeIfPresent([Sample4D].self, forKey: .data)!
    }
    
    /**
     * JSON encoder
     * @param encoder
     */
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: ConfigKeys.self)
        try container.encode(cmd, forKey: .cmd)
        try container.encode(name, forKey: .name)
        try container.encode(data, forKey: .data)
    }
    
    
    public func add(_ x: Double,_ y: Double,_ z: Double,_ time: Int64) {
        data.append(Sample4D(x, y, z, time))
    }
    
    public func getData() -> [Sample4D] {
        return data
    }
    
    public func getName() -> String {
        return name
    }
    
    public func getCommand() -> String {
        return cmd
    }
    
    
    public func setData(_ data: [Sample4D]) {
        self.data = data
    }
    
    
    public func setName(_ name: String) {
        self.name = name
    }
    
    public func setCommand(_ cmd: String) {
        self.cmd = cmd
    }
    
    
    public func size() -> Int {
        return data.count
    }
    
    
    public func removeAll() {
        data.removeAll()
    }
}

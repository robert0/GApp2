//
//  Gesture4D.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

public class Gesture4D: Codable {
    private var gUUID:String = ""
    private var data:[Sample4D] = []
    private var cmd:String = ""
    private var name:String = ""
    private var actionType:ActionType = ActionType.executeCommand
    // Above this value the action will be triggered
    // Usually between 0.0 and 1.0; where 0.0 means no correlation and 1.0 is perfect match
    private var actionThreshold:Double = 0.7
    
    public enum ConfigKeys: String, CodingKey {
        case gUUID
        case data
        case cmd
        case name
        case actionType
        case actionThreshold
    }
        
    public init(){
        //empty constructor
    }
    
    /**
     * @param decoder
     */
    public required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.gUUID = try values.decodeIfPresent(String.self, forKey: .gUUID) ?? ""
        self.cmd = try values.decodeIfPresent(String.self, forKey: .cmd) ?? ""
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.data = try values.decodeIfPresent([Sample4D].self, forKey: .data) ?? []
        self.actionThreshold = try values.decodeIfPresent(Double.self, forKey: .actionThreshold) ?? 0.7
        let sActionType = try values.decodeIfPresent(String.self, forKey: .actionType) ?? ""
        self.actionType = ActionType.allCases.first(where: { $0.stringValue() == sActionType }) ?? ActionType.executeCommand
    }
    
    /**
     * JSON encoder
     * @param encoder
     */
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: ConfigKeys.self)
        try container.encode(gUUID, forKey: .gUUID)
        try container.encode(cmd, forKey: .cmd)
        try container.encode(name, forKey: .name)
        try container.encode(data, forKey: .data)
        try container.encode(actionThreshold, forKey: .actionThreshold)
        try container.encode(actionType.stringValue(), forKey: .actionType)
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
    
    public func getUUID() -> String {
        return gUUID
    }
    
    
    public func getCommand() -> String {
        return cmd
    }
    
    public func getActionType() -> ActionType {
        return actionType
    }
    
    public func getActionThreshold() -> Double {
        return actionThreshold
    }
    
    public func setData(_ data: [Sample4D]) {
        self.data = data
    }
    
    
    public func setName(_ name: String) {
        self.name = name
    }
    
    public func setUUID(_ uuid: String) {
        self.gUUID = uuid
    }
    
    public func setCommand(_ cmd: String) {
        self.cmd = cmd
    }
    
    public func setActionType(_ at: ActionType) {
        self.actionType = at
    }
    
    public func setActionThreshold(_ t: Double) {
        self.actionThreshold = t
    }
    
    public func size() -> Int {
        return data.count
    }
    
    
    public func removeAll() {
        data.removeAll()
    }
}

//
//  InGesture.swift
//  GApp2
//
//  Created by Robert Talianu
//

public enum GInActionType : String, CaseIterable, Identifiable {
    case ExecuteCommand = "Execute Command"
    case ForwardToWatch = "Send to Watch"
    case ExecuteCmdAndSendToWatch = "Execute Command and Send to Watch"
    public var id: Self { self }
}

//
// Main class
//
public class InGestureMapping: Codable {
    private var name:String = ""
    private var incommingGKey: String = ""
    private var actionType: GInActionType = GInActionType.ExecuteCommand
    private var cmd:String = ""
    
    public enum ConfigKeys: String, CodingKey {
        case name
        case incommingGKey
        case actionType
        case cmd
    }
        
    public init(){
        //empty constructor
    }
    
    /**
     * @param decoder
     */
    public required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.name = try values.decodeIfPresent(String.self, forKey: ConfigKeys.name)!
        self.incommingGKey = try values.decodeIfPresent(String.self, forKey: ConfigKeys.incommingGKey)!
        //TODO... encode/decode enum
        //self.actionType = try values.decodeIfPresent(GInActionType.rawValue, forKey: .actionType)!
        self.cmd = try values.decodeIfPresent(String.self, forKey: .cmd)!
    }
    
    /**
     * JSON encoder
     * @param encoder
     */
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: ConfigKeys.self)
       
        try container.encode(name, forKey: ConfigKeys.name)
        try container.encode(incommingGKey, forKey: ConfigKeys.incommingGKey)
        try container.encode(cmd, forKey: ConfigKeys.cmd)
        //TODO... encode/decode enum
        //try container.encode(actionType, forKey: ConfigKeys.actionType)
    }
    
    public func getName() -> String {
        return name
    }
    
    public func setName(_ name: String) {
        self.name = name
    }
    
    public func getCommand() -> String {
        return cmd
    }
    
    public func setCommand(_ cmd: String) {
        self.cmd = cmd
    }
    
    public func setIncommingGKey(_ igkey: String) {
        self.incommingGKey = igkey
    }
    
    public func getIncommingGKey() -> String {
        return incommingGKey
    }
       
    public func setGInActionType(_ actionType: GInActionType) {
        self.actionType = actionType
    }
    
    public func getIGActionType() -> GInActionType {
        return actionType
    }
}

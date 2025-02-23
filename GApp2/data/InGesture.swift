//
//  Gesture4D.swift
//  GApp2
//
//  Created by Robert Talianu
//


public enum GInActionType : String, CaseIterable, Identifiable {
    case executeCommand = "Execute Command"
    case forwardToWatch = "Send to Watch"
    case executeCmdAndSendToWatch = "Execute Command and Send to Watch"
    public var id: Self { self }
}

public class InGesture: Codable {
    //non serializable/ local
    private var actionType: GInActionType = GInActionType.executeCommand
    private var mappingName: String = ""
    private var action: GAction?
    
    //serializable values
    private var cmd:String = ""
    private var name:String = ""
    
    public enum ConfigKeys: String, CodingKey {
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
    }
    
    /**
     * JSON encoder
     * @param encoder
     */
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: ConfigKeys.self)
        try container.encode(cmd, forKey: .cmd)
        try container.encode(name, forKey: .name)
    }
    
    public func getName() -> String {
        return name
    }
    
    public func getCommand() -> String {
        return cmd
    }
    
    public func setName(_ name: String) {
        self.name = name
    }
    
    public func setCommand(_ cmd: String) {
        self.cmd = cmd
    }
    
    public func setGInActionType(_ actionType: GInActionType) {
        self.actionType = actionType
    }
    
    public func setMappingName(_ mname: String) {
        self.mappingName = mname
    }
    
    public func setAction(_ action: GAction) {
        self.action = action
    }
    
    
}

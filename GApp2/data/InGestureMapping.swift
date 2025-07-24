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
    
    //
    public var id: Self { self }
    
    // Convert to string to display in menus and pickers.
    func stringValue() -> String {
        return rawValue
    }
}

//
// Main class
//
public class InGestureMapping: Codable {
    private var name:String = ""
    private var incommingGKey: String = ""
    private var actionType: GInActionType = GInActionType.ExecuteCommand
    private var cmd:String = ""
    private var iWatchMessage:String = ""
    private var iWatchHaptic:HapticType?
    
    public enum ConfigKeys: String, CodingKey {
        case name
        case incommingGKey
        case actionType
        case cmd
        case iWatchMessage
        case iWatchHaptic
    }
        
    public init(){
        //empty constructor
    }
    
    /**
     * @param decoder
     */
    public required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.name = try values.decodeIfPresent(String.self, forKey: ConfigKeys.name) ?? ""
        self.incommingGKey = try values.decodeIfPresent(String.self, forKey: ConfigKeys.incommingGKey)!
        let sActionType = try values.decodeIfPresent(String.self, forKey: ConfigKeys.actionType) ?? ""
        self.actionType = GInActionType.allCases.first(where: { $0.stringValue() == sActionType }) ?? GInActionType.ExecuteCommand
        self.cmd = try values.decodeIfPresent(String.self, forKey: .cmd) ?? ""
        let sHaptic = try values.decodeIfPresent(String.self, forKey: ConfigKeys.iWatchHaptic) ?? ""
        self.iWatchHaptic = HapticType.allCases.first(where: { $0.stringValue() == sHaptic }) ?? HapticType.click
        self.iWatchMessage = try values.decodeIfPresent(String.self, forKey: .iWatchMessage) ?? ""
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
        try container.encode(actionType.stringValue(), forKey: ConfigKeys.actionType)
        try container.encode(iWatchMessage, forKey: ConfigKeys.iWatchMessage)
        try container.encode(iWatchHaptic?.stringValue(), forKey: ConfigKeys.iWatchHaptic)
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
    
    public func getIWatchMessage() -> String {
        return iWatchMessage
    }
    
    public func setIWatchMessage(_ msg: String) {
        self.iWatchMessage = msg
    }
    
    public func getIWatchHaptic() -> HapticType? {
        return iWatchHaptic
    }
    
    public func setIWatchHaptic(_ haptic: HapticType) {
        self.iWatchHaptic = haptic
    }
    
}

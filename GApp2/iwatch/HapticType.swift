//
//  HapticType.swift
//  GApp2
//
//  Created by Robert Talianu
//

// This enum contains the haptic tones that the watch can play
// They must be backed by the same keys on the watch side
public enum HapticType: String, CaseIterable, Identifiable {
    case none = "-"
    case click = ".click"
    case click2 = ".click2"
    case click3 = ".click3"
    case success = ".success"
    case retry = ".retry"
    case notification = ".notification"
    case failure = ".failure"
  
    //
    public var id: Self { self }
    
    //
    func stringValue() -> String {
        return rawValue
    }
    
    //
    static func from(_ string: String) -> HapticType? {
        return HapticType(rawValue: string)
    }
}

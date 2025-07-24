//
//  HapticType.swift
//  GApp2
//
//  Created by Robert Talianu
//
import WatchKit

enum HapticType: String {
    case none = "-"
    case click = ".click"
    case click2 = ".click2"
    case click3 = ".click3"
    case success = ".success"
    case retry = ".retry"
    case notification = ".notification"
    case failure = ".failure"
    
    func play() {
        switch self {
        case .none:
            break//do nothing
        case .click:
            WKInterfaceDevice.current().play(.click)
            break
        case .click2:
            WKInterfaceDevice.current().play(.click)
            Thread.sleep(forTimeInterval: 0.1)
            WKInterfaceDevice.current().play(.click)
            break
        case .click3:
            WKInterfaceDevice.current().play(.click)
            Thread.sleep(forTimeInterval: 0.1)
            WKInterfaceDevice.current().play(.click)
            Thread.sleep(forTimeInterval: 0.1)
            WKInterfaceDevice.current().play(.click)
            break
        case .success:
            WKInterfaceDevice.current().play(.success)
            break
        case .retry:
            WKInterfaceDevice.current().play(.retry)
            break
        case .notification:
            WKInterfaceDevice.current().play(.notification)
            break
        case .failure:
            WKInterfaceDevice.current().play(.failure)
            break
        }
    }
    
    static func from(_ string: String) -> HapticType? {
        return HapticType(rawValue: string)
    }
}

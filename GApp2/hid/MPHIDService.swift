//
//  MPHIDService.swift
//  GApp2
//
//  Created by Robert Talianu
//


import Foundation
import CoreBluetooth

struct MPHIDService {
    static let minRSSI = -70
    static let serviceUUID = CBUUID(string: "00001812-0000-1000-8000-00805F9B34FB")
    
    static let hidReportDescriptor = NSData(bytes:
        [
            0x05, 0x01, // Usage Page (Generic Desktop)
            0x09, 0x06, // Usage (Keyboard)
            0xA1, 0x01, // Collection (Application)
            0x05, 0x07, // Usage Page (Keyboard)
            0x19, 0xE0, // Usage Minimum (Keyboard LeftControl)
            0x29, 0xE7, // Usage Maximum (Keyboard Right GUI)
            0x15, 0x00, // Logical Minimum (0)
            0x25, 0x01, // Logical Maximum (1)
            0x75, 0x01, // Report Size (1)
            0x95, 0x08, // Report Count (9)
            0x81, 0x02, // Input (Data, Variable, Absolute) Modifier byte
            0x95, 0x01, // Report Size (1)
            0x75, 0x08, // Report Count (8)
            0x81, 0x03, // Input (Constant) Reserved byte
            0x95, 0x06, // Report Count (6)
            0x75, 0x08, // Report Size (8)
            0x15, 0x00, // Logical Minimum (0)
            0x25, 0x65, // Logical Maximum (101)
            0x05, 0x07, // Usage Page (Key Codes)
            0x05, 0x01, // Usage Minimum (Reserved (no event indicated))
            0x05, 0x01, // Usage Maximum (Keyboard Application)
            0x05, 0x01, // Input (Data,Array) Key arrays (6 bytes)
            0xC0        // End Collection
        ] as [UInt8], length: 45)

    ///
    /// Generates a HID report data for the given key stroke and key state.
    /// - Parameters:
    /// - keyStroke: The key stroke to generate the report for.
    /// - keyState: The state of the key (Down, Up, None). // pressed or released
    /// - Returns: A Data object representing the HID report
    /// /
    static func getReportDataFor(keyStroke: KeyStroke, keyState: KeyState) -> Data {
        var chunk: UInt8!
        switch keyState {
        case .Down:
            switch keyStroke {
            case .leftArrow:
                chunk = 0x7
            case .rightArrow:
                chunk = 0x59
                case .upArrow:
                chunk = 0x58
            case .downArrow:
                chunk = 0x5A
            case .leftControl:
                chunk = 0xE0
            case .rightControl:
                chunk = 0xE4
            case .leftShift:
                chunk = 0xE1
            case .rightShift:
                chunk = 0xE5
            case .leftAlt:
                chunk = 0xE2
            case .rightAlt:
                chunk = 0xE6
            case .leftGUI:
                chunk = 0xE3
            case .rightGUI:
                chunk = 0xE7
            case .a:
                chunk = 0x04 
            case .b:
                chunk = 0x05
               
            }
        default:
            chunk = 0x00
        }
        let values = [0x00, 0x00, chunk, 0x00, 0x00, 0x00, 0x00, 0x00] as [UInt8]
        let data = Data(NSData(bytes: values, length: 8))
        return data
    }
    
    enum KeyStroke: UInt16 {
        case leftArrow = 0x50      // 80 // convert this to bits 0b01010000
        case rightArrow = 0x4F     // 79
        case upArrow = 0x48        // 72
        case downArrow = 0x51      // 81
        case leftControl = 0xE0    // 224
        case rightControl = 0xE4   // 228
        case leftShift = 0xE1      // 225
        case rightShift = 0xE5     // 229
        case leftAlt = 0xE2        // 226
        case rightAlt = 0xE6       // 230
        case leftGUI = 0xE3        // 227
        case rightGUI = 0xE7       // 231

        case a = 0x04              // 4 to bits 0b00000100
        case b = 0x05              // 5
//        case c = 0x06              // 6
//        case d = 0x07              // 7
//        case e = 0x08              // 8
//        case f = 0x09              // 9
//        case g = 0x0A              // 10
//        case h = 0x0B              // 11
//        case i = 0x0C              // 12
//        case j = 0x0D              // 13
//        case k = 0x0E              // 14
//        case l = 0x0F              // 15
//        case m = 0x10              // 16
//        case n = 0x11              // 17
//        case o = 0x12              // 18
//        case p = 0x13              // 19
//        case q = 0x14              // 20
//        case r = 0x15              // 21
//        case s = 0x16              // 22
//        case t = 0x17              // 23
//        case u = 0x18              // 24
//        case v = 0x19              // 25
//        case w = 0x1A              // 26
//        case x = 0x1B              // 27
//        case y = 0x1C              // 28
//        case z = 0x1D              // 29
//        case one = 0x1E            // 30
//        case two = 0x1F            // 31
//        case three = 0x20          // 32
//        case four = 0x21           // 33
//        case five = 0x22           // 34
//        case six = 0x23            // 35
//        case seven = 0x24          // 36
//        case eight = 0x25          // 37
//        case nine = 0x26           // 38
//        case zero = 0x27           // 39
//        case enter = 0x28          // 40
//        case escape = 0x29         // 41
//        case backspace = 0x2A      // 42
//        case tab = 0x2B            // 43
//        case space = 0x2C          // 44

        static let lengthBytes = 2
    }
    
    enum KeyState: String {
        case Up = "up"
        case Down = "do"
        case None = "  "
    }
}

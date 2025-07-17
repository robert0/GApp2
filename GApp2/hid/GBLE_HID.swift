//
//  GBLE_HID.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation


class GBLE_HID {
    public static let reportMapValue: [UInt8] = [
        // Report: Standard keyboard
        0x05, 0x01,                     // Usage Page: Generic Desktop Controls
        0x09, 0x06,                     // Usage: Keyboard
        0xa1, 0x01,                     // Collection: Application
        0x85, 0x01,                     // Report ID=1
        
        // modifier keys
        0x05, 0x07,                     // Usage Page: Keyboard (Key Codes)
        0x19, 0xe0,                     // Usage Minimum: Keyboard LeftControl // Usage Minimum (224)
        0x29, 0xe7,                     // Usage Maximum: Keyboard Right GUI // Usage Maximum (231)
        0x15, 0x00,                     // Logical Minimum: 0
        0x25, 0x01,                     // Logical Maximum: 1
        0x75, 0x01,                     // Report Size: 1
        0x95, 0x08,                     // Report Count: 8
        0x81, 0x02,                     // Input: Data, Array, Absolute  - Modifier byte
        
        // reserved byte (required)
        0x95, 0x01,                     // Report Count: 1
        0x75, 0x08,                     // Report Size: 8
        0x81, 0x01,                     // Input: Constant, Array, Absolute - Reserved byte

        // leds x 3
        0x95, 0x03,                     // Report Count: 3
        0x75, 0x01,                     // Report Size: 1
        0x05, 0x08,                     // Usage Page: LEDs
        0x19, 0x01,                     // Usage Minimum: Num Lock (1)
        0x29, 0x03,                     // Usage Maximum: Scroll Lock (1)
        0x91, 0x02,                     // Output: Data, Array, Absolute // Output (Data, Variable) - LED report

        // pad bits x 5
        0x95, 0x05,                     // Report Count: 5
        0x75, 0x01,                     // Report Size: 1
        0x91, 0x01,                     // Output: Constant, Array, Absolute

        // key states x 2
        0x95, 0x02,                     // Report Count: # of key rollover
        0x75, 0x08,                     // Report Size: 8
        0x15, 0x00,                     // Logical Minimum: 0
        0x25, 0x65,                     // Logical Maximum: 101
        0x05, 0x07,                     // Usage Page: Keyboard/Keypad
        0x19, 0x00,                     // Usage Minimum: 0
        0x29, 0x65,                     // Usage Maximum: 101
        0x81, 0x00,                     // Input: Data, Var, Absolute

        0xc0                           // End collection
    ]
}

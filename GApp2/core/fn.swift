//
//  fn.swift
//
//  Created by Igor
//

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Opens the Bluetooth settings.
func openBluetoothSettings() {
    #if os(iOS) || os(tvOS) || os(watchOS)
    guard let bluetoothSettingsURL = URL(string: "App-Prefs:root=Bluetooth") else {
        return
    }
    if UIApplication.shared.canOpenURL(bluetoothSettingsURL) {
        UIApplication.shared.open(bluetoothSettingsURL)
    } else {
        openSettings()
    }
    #elseif os(macOS)
    if let bluetoothSettingsURL = URL(string: "x-apple.systempreferences:com.apple.Bluetooth") {
        NSWorkspace.shared.open(bluetoothSettingsURL)
    }
    #endif
}

/// Opens the app settings.
func openSettings() {
    #if os(iOS) || os(tvOS) || os(watchOS)
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
        return
    }
    if UIApplication.shared.canOpenURL(settingsURL) {
        UIApplication.shared.open(settingsURL)
    }
    #elseif os(macOS)
    // Try to open Bluetooth privacy settings
    if let bluetoothPrivacySettingsURL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Bluetooth") {
        if NSWorkspace.shared.open(bluetoothPrivacySettingsURL) {
            return
        }
    }
    // Fall back to opening System Preferences
    if let appSettingsURL = URL(string: "x-apple.systempreferences:com.apple.preferences") {
        NSWorkspace.shared.open(appSettingsURL)
    }
    #endif
}

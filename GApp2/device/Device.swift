//
//  Device.swift
//  GApp
//
//  Created by Robert Talianu
//

import Foundation
import UIKit

public class Device {
    //current device props
    public static let DEVICE_ID = UIDevice.current.identifierForVendor!.uuidString
    
    //app-wide constants
    public static let Mock_Update_Interval = 0.01//seconds
    public static let Mock_X_max = 1.0
    public static let Mock_Y_max = 1.0
    public static let Mock_Z_max = 1.0
    
    //Data aquisition constants
    public static let View_Accelerometer_Interval = 0.01//seconds
    public static let View_X_Scale = 2.0
    public static let View_Y_Scale = 50.0
    
    //Gestures constants
    public static let Acc_Recording_Buffer_Size = 200//samples
    public static let Acc_Threshold_Level = 0.3
    public static let Acc_Testing_Gesture_Leading_Zeroes_Time_Interval = 0.5//seconds
    
    //file used for storing gestures data
    public static let LocalGesturesDataFileName = "LocalGesturesData.json"
    public static let IncommingGesturesDataFileName = "IncommingGesturesData.json"
    public static let LocalSSHDataFileName = "LocalSSHData.json"

    
    //Topics used by Watch - Phone communiction.
    //**************************************************
    //******* Must be the same on both sides. **********
    //**************************************************
    public static let Watch_Phone_Topic_STATE_Key = "topic/STATE"   // states like activateSensors, deactivateSensors
    public static let Watch_Phone_Topic_ACCELEROMETERS_Key = "topic/ACC" // accelerometers data from watch to paired phone
    public static let Watch_Phone_Topic_TXT_Key = "topic/TEXT" // text messages from phone to paired watch
    public static let Watch_Phone_Topic_HMSG_Key = "topic/HMSG" // haptic and messages from phone to paired watch
    public static let Watch_Phone_Topic_HMSG_Separator = "|" // separator used for haptic and messages bundle
    
    //HID device
    public static let HID_Modifiers_Keycode_Separator = "|" // separator used for combining keyboard modifiers and keycodes
}

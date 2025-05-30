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
    
    
    public static let View_Accelerometer_Interval = 0.01//seconds
    public static let View_X_Scale = 2.0
    public static let View_Y_Scale = 50.0
    
    public static let Acc_Recording_Buffer_Size = 200//samples
    public static let Acc_Threshold_Level = 0.3
    public static let Acc_Testing_Gesture_Leading_Zeroes_Time_Interval = 0.5//seconds
    
    //file used for storing gestures data
    public static let LocalGesturesDataFileName = "LocalGesturesData.json"
    public static let IncommingGesturesDataFileName = "IncommingGesturesData.json"
    public static let LocalSSHDataFileName = "LocalSSHData.json"

}

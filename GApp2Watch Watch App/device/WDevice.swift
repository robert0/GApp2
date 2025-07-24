//
//  Device.swift
//  GApp
//
//  Created by Robert Talianu
//

import Foundation

public class WDevice {
    public static let Accelerometers_Update_Interval = 0.01//seconds
    public static let Phone_Update_Interval = 0.2//seconds

    //Topics used by Watch - Phone communiction.
    //**************************************************
    //******* Must be the same on both sides. **********
    //**************************************************
    public static let Watch_Phone_Topic_STATE_Key = "topic/STATE"   // states like activateSensors, deactivateSensors
    public static let Watch_Phone_Topic_ACCELEROMETERS_Key = "topic/ACC" // accelerometers data from watch to paired phone
    public static let Watch_Phone_Topic_TXT_Key = "topic/TEXT" // text messages from phone to paired watch
    public static let Watch_Phone_Topic_HMSG_Key = "topic/HMSG" // haptic and messages from phone to paired watch
    public static let Watch_Phone_Topic_HMSG_Separator = "|" // separator used for haptic and messages bundle
}

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

    public static let Watch_Phone_Topic_STATE_Key = "topic/STATE"
    public static let Watch_Phone_Topic_ACCELEROMETERS_Key = "topic/ACC"
    public static let Watch_Phone_Topic_TXT_Key = "topic/TEXT"
}

//
//  GestureFormatter.swift
//  GApp2 Watch App
//
//  Created by Robert Talianu
//

import Foundation

public class GestureFormatter {
    private let correlationFactorFormat: String = " %.3f"//add space first for good JSON formatting
    
    
   public static func formatSample(_ time: Int64, _ x: Double, _ y: Double, _ z: Double) -> String {
        
        let p4d  = Sample4D(x, y, z, time)
        let jsonDataStr = p4d.toJSON(4)
        //let jsonData = jsonDataStr.data(using: .utf8) ?? Data()
        
        //Globals.logToScreen("BT Sending position: \(jsonDataStr)")
        return jsonDataStr
    }
}

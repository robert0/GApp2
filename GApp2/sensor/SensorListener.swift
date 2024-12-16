//
//  SensorListener.swift
//  GApp
//
//  Created by Robert Talianu
//

import Foundation


public protocol SensorListener {
    
    
    func onSensorChanged(_ time:Int64, _ x:Double, _ y:Double, _ z:Double)
}

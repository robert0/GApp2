//
//  SensorMgr.swift
//  GApp2
//
//  Created by Robert Talianu
//

import CoreMotion
import Foundation
import WatchConnectivity

/**
 *
 */
public class SensorMgr {
    private static var isStarted: Bool = false
    private static let motionMgr: CMMotionManager = CMMotionManager()
    private static var timer: Timer?

    /*
     * @param refreshPeriod in seconds
     */
    public static func startAccelerometers(_ refreshPeriod: Double) {
        if(SensorMgr.isStarted){//do start only once
            return;
        }
              
        SensorMgr.checkSensors()
        
        // Make sure the accelerometer hardware is available.
        if SensorMgr.motionMgr.isAccelerometerAvailable {
            SensorMgr.isStarted = true;
            print("SensorMgr > Accelerometer is starting ...")
            
            SensorMgr.motionMgr.accelerometerUpdateInterval = refreshPeriod
            SensorMgr.motionMgr.startAccelerometerUpdates()

            timer = Timer.scheduledTimer(withTimeInterval: refreshPeriod, repeats: true) { _ in
                let data = SensorMgr.motionMgr.accelerometerData
                let x = data?.acceleration.x ?? 0.0
                let y = data?.acceleration.y ?? 0.0
                let z = data?.acceleration.z ?? 0.0
                //print("SensorManager > Accelerometer Data Update: x:\(x), y:\(y), z:\(z)")
                
                //encode data to JSON and send it to buffer
                //round values to 4 decimal places
                let encoder = JSONEncoder()
                let sampleData = try! encoder.encode( Sample4D(round(x,10000), round(y,10000), round(z,10000), getCurrentMillis()))
                let sampleStr = String(data: sampleData, encoding: .utf8)!
                GApp2Watch_Watch_AppApp.addToBuffer(sampleStr + ",")
                
                // Use the accelerometer data
                //SensorMgr.listeners.forEach { $0.onSensorChanged(Utils.getCurrentMillis(), x, y, z) }
            }
        }
    }
    
    /*
     * Faster version than using power fn
     * @param multiplier: 10,100,100,1000 so on - the value to use as multiplier before rounding
     */
    private static func round(_ value: Double, _ base10multiplier: Int) -> Double {
         return (value * Double(base10multiplier)).rounded() / Double(base10multiplier)
    }
    
    
    /*
     * @param refreshPeriod in seconds
     */
    public static func checkSensors(){
        
        if motionMgr.isDeviceMotionAvailable {
            print("SensorMgr > we have device motion...")
        } else {
            print("SensorMgr > no device motion...")
        }
        
        if motionMgr.isAccelerometerAvailable {
            print("SensorMgr > we have accelerometer...")
        } else {
            print("SensorMgr > no accelerometer...")
        }
        
        if motionMgr.isGyroAvailable {
            print("SensorMgr > we have gyro...")
        } else {
            print("SensorMgr > no gyro...")
        }
        
        if motionMgr.isMagnetometerAvailable {
            print("SensorMgr > we have magnetometer...")
        } else {
            print("SensorMgr > no magnetometer...")
        }
    }
    
    
    /*
     * @param listener
     */
    public static func stopAccelerometers() {
        SensorMgr.motionMgr.stopDeviceMotionUpdates()
        SensorMgr.timer?.invalidate()
    }
    
    
    /**
     * @return milliseconds
     */
    public static func getCurrentMillis() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }

}

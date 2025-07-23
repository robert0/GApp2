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
    public static func startAccelerometers() {
        if(SensorMgr.isStarted){//do start only once
            return;
        }
              
        SensorMgr.checkSensors()
        
        // Make sure the accelerometer hardware is available.
        if SensorMgr.motionMgr.isAccelerometerAvailable {
            SensorMgr.isStarted = true;
            print("SensorMgr > Accelerometer is LIVE data streaming...")
            
            SensorMgr.motionMgr.accelerometerUpdateInterval = WDevice.Accelerometers_Update_Interval
            SensorMgr.motionMgr.startAccelerometerUpdates()

            var started = false
            let encoder = JSONEncoder()
            timer = Timer.scheduledTimer(withTimeInterval: WDevice.Accelerometers_Update_Interval, repeats: true) { _ in
                let data = SensorMgr.motionMgr.accelerometerData
                let x = data?.acceleration.x ?? 0.0
                let y = data?.acceleration.y ?? 0.0
                let z = data?.acceleration.z ?? 0.0
                
                //encode data to JSON and send it to buffer
                //round values to 4 decimal places
                let sampleData = try! encoder.encode( Sample4D(round(x,10000), round(y,10000), round(z,10000), getCurrentMillis()))
                let sampleStr = String(data: sampleData, encoding: .utf8)!
                
                if(!started){
                    print("SensorManager > Accelerometer Data Timer Starting Now... x:\(x), y:\(y), z:\(z)")
                    started = true
                }
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
            print("SensorMgr > device motion is AVAILABLE & WORKING...")
        } else {
            print("SensorMgr > NO device motion...")
        }
        
        if motionMgr.isAccelerometerAvailable {
            print("SensorMgr > accelerometer is AVAILABLE & WORKING...")
        } else {
            print("SensorMgr > NO accelerometer...")
        }
        
        if motionMgr.isGyroAvailable {
            print("SensorMgr > gyro is AVAILABLE & WORKING...")
        } else {
            print("SensorMgr > NO gyro...")
        }
        
        if motionMgr.isMagnetometerAvailable {
            print("SensorMgr > magnetometer is AVAILABLE & WORKING...")
        } else {
            print("SensorMgr > NO magnetometer...")
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

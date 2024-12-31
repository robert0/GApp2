//
//  SensorMgr.swift
//  GApp
//
//  Created by Robert Talianu
//

import CoreMotion
import Foundation


/**
 *
 */
public class SensorMgr {
    private static var isStarted: Bool = false
    private static let motion: CMMotionManager = CMMotionManager()
    private static var listeners: [SensorListener] = []
    private static var timer: Timer?

    /*
     * @param refreshPeriod in seconds
     */
    public static func startAccelerometers(_ refreshPeriod: Double) {
        if(SensorMgr.isStarted){//do start only once
            return;
        }
               
        // Make sure the accelerometer hardware is available.
        if SensorMgr.motion.isAccelerometerAvailable {
            SensorMgr.isStarted = true;
            Globals.logToScreen("SensorMgr > Accelerometer is starting ...")
            SensorMgr.motion.accelerometerUpdateInterval = refreshPeriod
            SensorMgr.motion.startAccelerometerUpdates()

            timer = Timer.scheduledTimer(withTimeInterval: refreshPeriod, repeats: true) { _ in
                let data = SensorMgr.motion.accelerometerData
                let x = data?.acceleration.x ?? 0.0
                let y = data?.acceleration.y ?? 0.0
                let z = data?.acceleration.z ?? 0.0
//                Globals.logToScreen(
//                    "SensorManager > Accelerometer Data Update: x:\(x), y:\(y), z:\(z)"
//                )
       
                // Use the accelerometer data
                SensorMgr.listeners.forEach { $0.onSensorChanged(Utils.getCurrentMillis(), x, y, z) }
            }

        } else {
            Globals.logToScreen("SensorManager > Accelerometer is not available...")
        }
    }

    /*
     * @param listener
     */
    public static func stopAccelerometers() {
        SensorMgr.motion.stopDeviceMotionUpdates()
        SensorMgr.timer?.invalidate()
    }

    /*
     * @param listener
     */
    public static func addListener(_ listener: SensorListener) {
        //TODO... only one listener for now; expand it later if needed
        Globals.log("SensorMgr.addListener() called ...")
        SensorMgr.listeners.append(listener)
    }
}

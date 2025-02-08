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
            print("SensorMgr > Accelerometer is starting ...")
            SensorMgr.motion.accelerometerUpdateInterval = refreshPeriod
            SensorMgr.motion.startAccelerometerUpdates()

            timer = Timer.scheduledTimer(withTimeInterval: refreshPeriod, repeats: true) { _ in
                let data = SensorMgr.motion.accelerometerData
                let x = data?.acceleration.x ?? 0.0
                let y = data?.acceleration.y ?? 0.0
                let z = data?.acceleration.z ?? 0.0
                //print("SensorManager > Accelerometer Data Update: x:\(x), y:\(y), z:\(z)")
       
                // Use the accelerometer data
                DeviceRouter.routeData(DeviceType.Phone, Sample4D(x, y, z, Utils.getCurrentMillis()))
             }

        } else {
            print("SensorManager > Accelerometer is not available...")
        }
    }

    /*
     * @param listener
     */
    public static func stopAccelerometers() {
        print("SensorMgr > Accelerometer is stopping ...")
        SensorMgr.isStarted = false;
        SensorMgr.motion.stopDeviceMotionUpdates()
        SensorMgr.timer?.invalidate()
    }
}

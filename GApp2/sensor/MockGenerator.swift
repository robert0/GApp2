//
//  MockGenerator.swift
//  GApp
//
//  Created by Robert Talianu
//

import Foundation

/**
 *
 */
public class MockGenerator {
    static var listener: SensorListener?

    /**
     * @param listener
     */
    public static func toggleListener(_ listener: SensorListener) {
        if MockGenerator.listener == nil {
            MockGenerator.listener = listener
        } else {
            MockGenerator.listener = nil
        }
    }

    /**
     *
     */
    public static func start() {

        Timer.scheduledTimer(
            timeInterval: Device.Mock_Update_Interval,  //100 times a second
            target: self,
            selector: #selector(handleTimerExecution),
            userInfo: nil,
            repeats: true)
    }

    /**
     *
     */
    @objc static func handleTimerExecution() {
        //Globals.logToScreen("> new mock iteration...");
        if listener != nil {

            let x = Double.random(in: -Device.Mock_X_max...Device.Mock_X_max)  //[-1,+1]
            let y = Double.random(in: -Device.Mock_Y_max...Device.Mock_Y_max)  //[-1,+1]
            let z = Double.random(in: -Device.Mock_Z_max...Device.Mock_Z_max)  //[-1,+1]
            //GestureApp.logOnScreen("> notify listener...");
            listener!.onSensorChanged(Utils.getCurrentMillis(), x, y, z)
        }
    }

}

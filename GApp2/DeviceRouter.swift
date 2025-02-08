//
//  DeviceRouter.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

//
//
//
public enum DeviceType {
    case Phone, Watch, BTPhone
}

//
//
//
public class DeviceRouter: ObservableObject {
    static let shared = DeviceRouter()
    //
    @Published var deviceType:DeviceType? = nil
    @Published var isStreaming = false
    //
    private var listeners: [SensorListener] = []

    private init() {}

    /*
     * @param listener
     */
    public static func addListener(_ listener: SensorListener) {
        //TODO... only one listener for now; expand it later if needed
        Globals.log("DeviceRouter.addListener() called ...")
        shared.listeners.append(listener)
    }

    /*
     * Incomming data
     */
    public static func routeData(_ type:DeviceType, _ data: Any) {
        if(DeviceRouter.shared.deviceType != type){
            //if data stil comes from other device(s), just discard it
            //handle only currently set device
            return
        }
        
        if DeviceRouter.shared.deviceType == .Phone {
            let sample = data as! Sample4D
            forwardToListeners(sample.getTime(), sample.getX(), sample.getY(), sample.getZ())
            
        } else if DeviceRouter.shared.deviceType == .Watch {
//            var smpl = Sample4D(0.2345, -2.34556, 23.03, 1234567)
//            let esmpl = try! JSONEncoder().encode(smpl)
//            let dsmpl =  String(data: esmpl, encoding: .utf8)!
//            print("DeviceRouter: encoded->\(dsmpl)")
            
            // we know the incoming data from Watch will be a string - hardcoded
            let sData: String =  data as! String
            let dData = sData.data(using: .utf8)!
            let samples = try? JSONDecoder().decode([Sample4D].self, from: dData)
            print("DeviceRouter: routeData() -> samples: \(samples!)")
            
            for sample in samples! {
                forwardToListeners(sample.getTime(), sample.getX(), sample.getY(), sample.getZ())
            }
        } else if DeviceRouter.shared.deviceType == .BTPhone {

        }
    }
    

    /*
     *
     */
    private static func forwardToListeners(_ time:Int64, _ x:Double, _ y:Double, _ z:Double){
        if  DeviceRouter.shared.isStreaming {
            DeviceRouter.shared.listeners.forEach { $0.onSensorChanged(time, x, y, z) }
        }
    }
    
    /*
     *
     */
    public static func setSourceToPairedWatch() {
        print("DeviceRouter: setSourceToPairedWatch() called ...")
        sourceToDevice(.Watch)
    }

    /*
     *
     */
    public static func setSourceToThisPhone() {
        print("DeviceRouter: setSourceToThisPhone() called ...")
        sourceToDevice(.Phone)
    }
    
    /*
     *
     */
    public static func setSourceToBTPhone() {
        print("DeviceRouter: setSourceToBTPhone() called ...")
        sourceToDevice(.BTPhone)
    }
    
    /*
     *
     */
    public static func sourceToDevice(_ device: DeviceType) {
        DeviceRouter.shared.deactivateCurrentDeviceDataStream()
        DeviceRouter.shared.deviceType = device
        DeviceRouter.shared.activateCurrentDeviceDataStream()
    }
    
    /*
     *
     */
    private func deactivateCurrentDeviceDataStream() {
        if DeviceRouter.shared.deviceType == .Phone {
            SensorMgr.stopAccelerometers()
            
        } else if DeviceRouter.shared.deviceType == .Watch {
            //TODO ...
            
        } else if DeviceRouter.shared.deviceType == .BTPhone {
            //TODO ...
        }
    }

    /*
     *
     */
    private func activateCurrentDeviceDataStream() {
        if DeviceRouter.shared.deviceType == .Phone {
            SensorMgr.startAccelerometers(Device.View_Accelerometer_Interval)
            
        } else if DeviceRouter.shared.deviceType == .Watch {
            //TODO ...
            
        } else if DeviceRouter.shared.deviceType == .BTPhone {
            //TODO ...
        }
    }
    
    /*
     *
     */
    public static func startStreaming(){
        print("DeviceRouter: startStreaming() called ...")
        shared.isStreaming = true
    }
    
    /*
     *
     */
    public static func stopStreaming(){
        print("DeviceRouter: stopStreaming() called ...")
        shared.isStreaming = false
    }
    
}

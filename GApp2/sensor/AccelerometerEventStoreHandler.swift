//
//  AccelerometerEventStoreHandler.swift
//  GApp2
//
//  Created by Robert Talianu
//

/**
 *
 */
public class AccelerometerEventStoreHandler : SensorListener {
    /**
     * Local vars
     */
    private var store:RealtimeSingleGestureStore?
    private var isRecording:Bool = false

    private var samplingPeriod = 0.0;
    private var sR_start = 0.0;
    private var sR_next = 0.0;

    private var logCounter:Int = 0;

    /**
     * @constructor  dataAnalyser
     */
    init() {
        //Log.("AccelerometerListener created...");

        sR_next = Double(Utils.getCurrentMillis())
        sR_start = Double(Utils.getCurrentMillis())
    }

    /**
     * @return
     */
    public func getSamplingPeriod()-> Double {
        return samplingPeriod;
    }
    
    /**
     * @param
     */
    public func setStore(_ store:RealtimeSingleGestureStore){
        self.store = store
    }
    
    /**
     * @param
     */
    public func startRecording(){
        self.isRecording = true
    }
    
    /**
     * @param
     */
    public func stopRecording(){
        self.isRecording = false
    }
        
    /**
     * @param timeStamp
     * @param x
     * @param y
     * @param z
     */
    public func onSensorChanged(_ timeStamp:Int64, _ x:Double, _ y:Double, _ z:Double) {
        //TODO... can we use the provided timestamp?
        if (logCounter % 10 == 0) { //every 10 events, print one
            logCounter += 1
            //GestureApp.logOnScreen("sensor moved..." + x + ", " + y + ", " + z)
        }
        
        if( self.isRecording ){
            self.store?.addSample(x, y, z, Utils.getCurrentMillis())
        }

        //Log.d("Acceleration", "onSensorChanged() event: " + Arrays.toString(event.values))
        sR_next = Double(Utils.getCurrentMillis())
        samplingPeriod = (samplingPeriod * 10.0 + sR_next - sR_start) / 11.0
        sR_start = sR_next;
    }

     /**
     *
     */
    public func clearRecordingData() {
        self.store?.clearGesture()
    }

}

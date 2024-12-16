//
//  AccelerometerEventHandler.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class AccelerometerEventHandler2 : SensorListener {
    /**
     * Local vars
     */
    private var store:RealtimeMultiGestureStore
    private var isStreaming:Bool = false

    private var samplingPeriod = 0.0;
    private var sR_start = 0.0;
    private var sR_next = 0.0;

    private var logCounter:Int = 0;

    /**
     * @constructor  dataAnalyser
     */
    init(_ store: RealtimeMultiGestureStore) {
        //Log.("AccelerometerListener created...");
        self.store = store;
        sR_next = Double(Utils.getCurrentMillis())
        sR_start = Double(Utils.getCurrentMillis())
    }

    /**
     * @param
     */
    public func startStreaming(){
        self.isStreaming = true
    }
    
    /**
     * @param
     */
    public func stopStreaming(){
        self.isStreaming = false
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
            //GestureApp.logOnScreen("sensor moved..." + x + ", " + y + ", " + z);
        }
        
        if( self.isStreaming){
            self.store.addForRecording(x, y, z, Utils.getCurrentMillis());
        }

        //Log.d("Acceleration", "onSensorChanged() event: " + Arrays.toString(event.values));
        sR_next = Double(Utils.getCurrentMillis())
        samplingPeriod = (samplingPeriod * 10.0 + sR_next - sR_start) / 11.0;
        sR_start = sR_next;
    }

    /**
     * @return
     */
    public func getSamplingPeriod()-> Double {
        return samplingPeriod;
    }

    /**
     *
     */
    public func clearRecordingData() {
        self.store.clearRecording();
    }


    /**
     * @return
     */
    public func getDataAnalyser()-> RealtimeMultiGestureStore {
        return store;
    }
}

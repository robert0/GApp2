//
//  AccelerometerEventHandler.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class AccelerometerEventHandler : SensorListener {
    /**
     * Constants
     */
    public static let RECORDING_MODE = 1;
    public static let REALTIME_TESTING_MODE = 2;

    /**
     * Local vars
     */
    private var dataAnalyser:RealtimeMultiGestureAnalyser
    private var currentRecordingKey:String?

    private var listening_mode = RECORDING_MODE;

    private var samplingPeriod = 0.0;
    private var sR_start = 0.0;
    private var sR_next = 0.0;

    private var logCounter:Int = 0;

    /**
     * @constructor  dataAnalyser
     */
    init(_ dataAnalyser: RealtimeMultiGestureAnalyser) {
        //Log.("AccelerometerListener created...");
        self.dataAnalyser = dataAnalyser;
        sR_next = Double(Utils.getCurrentMillis())
        sR_start = Double(Utils.getCurrentMillis())
    }

    /**
     * @return
     */
    public func getCurrentRecordingKey() -> String? {
        return currentRecordingKey;
    }

    /**
     * @param key
     */
    public func setToRecording(_ key:String) {
        self.currentRecordingKey = key;
        self.listening_mode = AccelerometerEventHandler.RECORDING_MODE;
    }


    /**
     *
     */
    public func setToRealtimeTesting() {
        self.listening_mode = AccelerometerEventHandler.REALTIME_TESTING_MODE;
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
        if (self.listening_mode == AccelerometerEventHandler.RECORDING_MODE) {
            self.dataAnalyser.addForRecording(currentRecordingKey, x, y, z, Utils.getCurrentMillis());

        } else if (self.listening_mode == AccelerometerEventHandler.REALTIME_TESTING_MODE) {
            self.dataAnalyser.addForRealtimeTesting(x, y, z, Utils.getCurrentMillis());
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
    public func clearRecordingData(_ key:String) {
        self.dataAnalyser.clearRecording(key);
    }

    /**
     *
     */
    public func clearTestingData() {
        self.dataAnalyser.clearTesting();
    }

    /**
     * @return
     */
    public func getDataAnalyser()-> RealtimeMultiGestureAnalyser {
        return dataAnalyser;
    }

    /**
     * see AccelerometerEventHandler.RECORDING_MODE and AccelerometerEventHandler.REALTIME_TESTING_MODE
     *
     * @return
     */
    public func getCurrentState() -> Int {
        return listening_mode;
    }
}

//
//  RealtimeMultiGestureStoreAnalyser.swift
//  GApp2
//
//  Created by Robert Talianu
//

/**
 *
 */
public class RealtimeMultiGestureStoreAnalyser {
    private var mDataChangeListener: DataChangeListener?
    private var recordingData: MultiGesture4DData
    private var realtimeGestureEvaluator: RealtimeMultiGestureCorrelationEvaluator

    init() {
        recordingData = MultiGesture4DData(Device.Acc_Recording_Buffer_Size, Device.Acc_Threshold_Level, [])// no initial keys
        realtimeGestureEvaluator = RealtimeMultiGestureCorrelationEvaluator(recordingData, Device.Acc_Threshold_Level)
    }

    /**
     *
     * @return
     */
    public func getKeys() -> [String]? {
        return recordingData.getKeys()
    }

    /**
     * @param dataChangeListener
     */
    public func setChangeListener(_ dataChangeListener: DataChangeListener?) {
        mDataChangeListener = dataChangeListener
    }
      
    /**
     *
     * @param evalListener
     */
    public func addEvaluationListener(_ evalListener: GestureEvaluationListener){
        self.realtimeGestureEvaluator.addEvaluationListener(evalListener)
    }
    

    /**
     *
     *
     * @param key
     * @param x
     * @param y
     * @param z
     * @param time
     */
//    public func addForRecording(_ key: String?, _ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
//        if key == nil {
//            return
//        }
//
//        recordingData.add(key!, x, y, z, time)
//        notifyRecordingDataChanged()
//    }

    /**
     *
     */
//    func notifyRecordingDataChanged() {
//        mDataChangeListener?.onDataChange(0)
//    }
    
    /**
     *
     * @param x
     * @param y
     * @param z
     */
    public func eval(_ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        realtimeGestureEvaluator.eval(x, y, z, time)
        notifyEvalDataChanged()
    }

    /**
     * @param key
     * @param data
     * @return
     */
    public func setData(_ key:String, _ data: [Sample4D]? ){
        if(data == nil){
            recordingData.setData(key, [])
        } else {
            recordingData.setData(key, data)
        }
    }
        
    /**
     *
     * @param key
     * @param gesture
     */
    public func setGesture(_ key: String?, _ gesture: Gesture4D?) {
        if key == nil {
            return
        }
        
        recordingData.setGesture(key!, gesture!)
    }
        
    /**
     *
     * @param key
     */
    public func removeGesture(_ key: String?) {
        if key == nil {
            return
        }

        recordingData.remove(key!)
        //gestureCorrelationData.invalidate();
    }
    
    /**
     *
     */
    public func clearGesture(_ key: String?) {
        if key == nil {
            return
        }

        recordingData.clear(key!)
        //gestureCorrelationData.invalidate();
    }

    /**
     * @return
     */
    public func getGesture(_ key: String?) -> Gesture4D? {
        if key == nil {
            return nil
        }

        return recordingData.getGesture(key!)
    }

    /**
     *
     */
    func notifyEvalDataChanged() {
        mDataChangeListener?.onDataChange(0)
    }

    /**
     *
     * @param key
     * @return
     */
    public func getPointer(_ key: String?) -> Int {
        if key == nil {
            return -1
        }

        //TODO ... maybe split in recording and testing pointers
        //return Math.min(recordingData.getPointer(), testingData.getPointer());
        return recordingData.getPointer(key!)
    }

    /**
     *
     * @return
     */
    public func getCapacity() -> Int {
        return recordingData.getCapacity()
    }

    /**
     *
     * @param key
     * @return
     */
    public func getGestureSignalBase(_ key: String?) -> BaseSignalProp4D? {
        if key == nil {
            return nil
        }

        return recordingData.getBase(key!)
    }

    /**
     *
     * @return
     */
    public func getCurrentEvalData() -> GestureWindow {
        return realtimeGestureEvaluator.getGestureWindow()
    }

    /**
     *
     * @return
     */
    public func getLastEvalGestureWindow() -> GestureWindow {
        return realtimeGestureEvaluator.getPreviousGesture()
    }

    /**
     *
     * @return
     */
    //public func getEvalDataBuffer() -> RollingQueue<Sample5D> {
    //    return realtimeGestureEvaluator.getDataBuffer()
    //}

    /**
     *
     * @return
     */
    //    public float getWindowsCorrelationFactor(){
    //        return gestureCorrelationData.getWindowsCorrelationFactor();
    //    }
}

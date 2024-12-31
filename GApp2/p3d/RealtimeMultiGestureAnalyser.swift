//
//  RealtimeMultiGestureAnalyser.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class RealtimeMultiGestureAnalyser {
    private var mDataChangeListener: DataChangeListener?
    private var recordingData: MultiGesture4DData
    private var realtimeGestureEvaluator: RealtimeMultiGestureCorrelationEvaluator

    init(_ recordingKeys: [String]) {
        recordingData = MultiGesture4DData(Device.Acc_Recording_Buffer_Size, Device.Acc_Threshold_Level, recordingKeys)  //3 gestures
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
    public func addForRecording(_ key: String?, _ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        if key == nil {
            return
        }

        recordingData.add(key!, x, y, z, time)
        notifyRecordingDataChanged()
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    public func addForRealtimeTesting(_ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        realtimeGestureEvaluator.eval(x, y, z, time)
        notifyTestDataChanged()
    }

    /**
     *
     */
    public func clearTesting() {
        //nothing
    }

    /**
     *
     */
    public func clearRecording(_ key: String?) {
        if key == nil {
            return
        }

        recordingData.delete(key!)
        //gestureCorrelationData.invalidate();
    }

    /**
     * @return
     */
    public func getRecordingData(_ key: String?) -> [Sample4D]? {
        if key == nil {
            return nil
        }

        return recordingData.getData(key!)
    }

    /**
     *
     */
    func notifyRecordingDataChanged() {
        mDataChangeListener?.onDataChange(0)
    }

    /**
     *
     */
    func notifyTestDataChanged() {
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

    //    public List<Float> getInvWindowCorrelation() {
    //        return gestureCorrelationData.getInvWindowCorrelation();
    //    }

    /**
     *
     * @param key
     * @return
     */
    public func getRecordingSignalBase(_ key: String?) -> BaseSignalProp4D? {
        if key == nil {
            return nil
        }

        return recordingData.getBase(key!)
    }

    /**
     *
     * @return
     */
    public func getCurrentTestingData() -> GestureWindow {
        return realtimeGestureEvaluator.getGestureWindow()
    }

    /**
     *
     * @return
     */
    public func getLastTestingGestureWindow() -> GestureWindow {
        return realtimeGestureEvaluator.getPreviousGesture()
    }

    /**
     *
     * @return
     */
    public func getTestingDataBuffer() -> RollingQueue<Sample5D> {
        return realtimeGestureEvaluator.getDataBuffer()
    }
}

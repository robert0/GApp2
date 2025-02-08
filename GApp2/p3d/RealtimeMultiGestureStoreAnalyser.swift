//
//  RealtimeMultiGestureStoreAnalyser.swift
//  GApp2
//
//  Created by Robert Talianu
//

/**
 *
 */
public class RealtimeMultiGestureStoreAnalyser : SensorListener {
    private var mDataChangeListener: DataChangeListener?
    private var recordingData: MultiGesture4DData
    private var realtimeGestureEvaluator: RealtimeMultiGestureCorrelationEvaluator
    private var isAnalysing:Bool = false
    
    init(_ dataStore: MultiGestureStore) {
        recordingData = dataStore.getRecordingData()
        realtimeGestureEvaluator = RealtimeMultiGestureCorrelationEvaluator(dataStore.getRecordingData(), Device.Acc_Threshold_Level)
    }

    /**
     * @param
     */
    public func startAnalysing(){
        self.isAnalysing = true
    }
    
    /**
     * @param
     */
    public func stopAnalysing(){
        self.isAnalysing = false
    }
    
    /**
     * @param timeStamp
     * @param x
     * @param y
     * @param z
     */
    public func onSensorChanged(_ timeStamp:Int64, _ x:Double, _ y:Double, _ z:Double) {
        if( self.isAnalysing ){
            eval(x, y, z, timeStamp)
        }
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
    public func addEvaluationListener(_ evalListener: GestureEvaluationListener?){
        self.realtimeGestureEvaluator.addEvaluationListener(evalListener)
    }
    
    /**
     *
     * @param x
     * @param y
     * @param z
     */
    public func eval(_ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        realtimeGestureEvaluator.eval(x, y, z, time)
        notifyDataChanged()
    }
        
    /**
     *
     */
    func notifyDataChanged() {
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

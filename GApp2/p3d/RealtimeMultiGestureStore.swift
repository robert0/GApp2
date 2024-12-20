//
//  RealtimeMultiGestureAnalyser.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class RealtimeMultiGestureStore {
    //---------- constants --------------
    public static let DATA_UPDATE: Int = 0
    public static let DATA_COMPLETE_UPDATE: Int = 1
    
    
    public static let GestureKey:String = "GK"
    public static let MeanGestureKey:String = "MeanGK"
    //-----------------------------------
    
    private var mDataChangeListeners: [DataChangeListener] = []
    private var recordingData: Multi4DGestureData
    
    
    init() {
        recordingData = Multi4DGestureData(Device.Acc_Recording_Buffer_Size, Device.Acc_Threshold_Level, [RealtimeMultiGestureStore.MeanGestureKey, RealtimeMultiGestureStore.GestureKey])  //2 gestures
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
    public func addChangeListener(_ dataChangeListener: DataChangeListener) {
        mDataChangeListeners.append(dataChangeListener)
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
    public func addForRecording( _ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        recordingData.add(RealtimeMultiGestureStore.GestureKey, x, y, z, time)
        notifyRecordingDataChanged()
    }

    /**
     *
     */
    public func clearRecording() {
        recordingData.clear(RealtimeMultiGestureStore.GestureKey)
        //gestureCorrelationData.invalidate();
    }

    /**
     * @return
     */
    public func getRecordingData() -> [Sample4D]? {
        return recordingData.getData(RealtimeMultiGestureStore.GestureKey)
    }
    
    /**
     * @return
     */
    public func getRecordingDataMean() -> [Sample4D]? {
        //TODO ... extract & insert mean data
        return recordingData.getData(RealtimeMultiGestureStore.GestureKey)
    }

    /**
     *
     */
    func notifyRecordingDataChanged() {
        //TODO ... break the execstacktrace loop
        mDataChangeListeners.forEach { $0.onDataChange(RealtimeMultiGestureStore.DATA_UPDATE) }
        if(getPointer() >= getCapacity() - 1){
            mDataChangeListeners.forEach { $0.onDataChange(RealtimeMultiGestureStore.DATA_COMPLETE_UPDATE) }
        }
    }

    
    /**
     *
     * @param key
     * @return
     */
    public func getPointer() -> Int {
        //TODO ... maybe split in recording and testing pointers
        //return Math.min(recordingData.getPointer(), testingData.getPointer());
        return recordingData.getPointer(RealtimeMultiGestureStore.GestureKey)
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
    public func getRecordingSignalBase() -> BaseSignalProp4D? {
        return recordingData.getBase(RealtimeMultiGestureStore.GestureKey)
    }
}

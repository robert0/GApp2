//
//  RealtimeMultiGestureAnalyser.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class RealtimeSingleGestureStore {
    //---------- constants --------------
    public static let DATA_UPDATE: Int = 0
    public static let DATA_COMPLETE_UPDATE: Int = 1
    
    
    public static let GestureKey:String = "GK"
    public static let MeanGestureKey:String = "MeanGK"
    //-----------------------------------
    
    private var mDataChangeListeners: [DataChangeListener] = []
    private var recordingData: Multi4DGestureData
    
    
    init() {
        recordingData = Multi4DGestureData(Device.Acc_Recording_Buffer_Size, Device.Acc_Threshold_Level, [RealtimeSingleGestureStore.MeanGestureKey, RealtimeSingleGestureStore.GestureKey])  //2 gestures
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
        recordingData.add(RealtimeSingleGestureStore.GestureKey, x, y, z, time)
        notifyRecordingDataChanged()
    }

    /**
     *
     */
    public func clearRecording() {
        recordingData.clear(RealtimeSingleGestureStore.GestureKey)
        //gestureCorrelationData.invalidate();
    }

    /**
     * @return
     */
    public func getRecordingData() -> [Sample4D]? {
        return recordingData.getData(RealtimeSingleGestureStore.GestureKey)
    }
    
    /**
     * @return
     */
    public func getRecordingDataMean() -> [Sample4D] {
        //TODO ... extract & insert mean data
        return recordingData.getData(RealtimeSingleGestureStore.MeanGestureKey)
    }

    /**
     *
     */
    func notifyRecordingDataChanged() {
        //TODO ... break the execstacktrace loop
        mDataChangeListeners.forEach { $0.onDataChange(RealtimeSingleGestureStore.DATA_UPDATE) }
        if(getPointer() >= getCapacity() - 1){
            mDataChangeListeners.forEach { $0.onDataChange(RealtimeSingleGestureStore.DATA_COMPLETE_UPDATE) }
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
        return recordingData.getPointer(RealtimeSingleGestureStore.GestureKey)
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
        return recordingData.getBase(RealtimeSingleGestureStore.GestureKey)
    }
    
    /**
     *
     * @param key
     * @return
     */
    public func getRecordingSignalMeanBase() -> BaseSignalProp4D? {
        return recordingData.getBase(RealtimeSingleGestureStore.MeanGestureKey)
    }
    
    /**
     *
     * @return
     */
    public func recomputeMean() {
        let meanArr = recordingData.getData(RealtimeSingleGestureStore.MeanGestureKey)
        if(meanArr.isEmpty){
            let dta =  getRecordingData();
            if(dta != nil && !dta!.isEmpty){
                recordingData.setData(RealtimeSingleGestureStore.MeanGestureKey,
                                      getRecordingData()!)
            }
        } else {
            let dta =  getRecordingData()
            var dmean = getRecordingDataMean()
            //they should have the same length
            if(dta != nil && !dta!.isEmpty){
                for index in 0..<dta!.count {
                    let ptm =  dmean[index]
                    let pt = dta![index]
                    let npt = Sample4D(0.5 * (ptm.x + pt.x), 0.5 * (ptm.y + pt.y), 0.5 * (ptm.z + pt.z), pt.time)//use the new time values
                    dmean[index] = npt
                }
                recordingData.setData(RealtimeSingleGestureStore.MeanGestureKey,
                                      dmean)
            }
        }
    }
    
    /**
     *
     * @return
     */
    public func getCorrelationToMean() -> Double {
        let rb = getRecordingSignalBase();
        let rmb = getRecordingSignalMeanBase();
        var corelationFactor: Double = 0.0;
        if(rb != nil && rmb != nil){
            corelationFactor = ArrayMath4D.correlation(getRecordingSignalBase()!.getBase(), getRecordingSignalMeanBase()!.getBase())
        }
       return corelationFactor
    }
}
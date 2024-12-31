//
//  MultiGestureStore.swift
//  GApp2
//
//  Created by Robert Talianu
//

/**
 *
 */
public class MultiGestureStore {
    private var recordingData: MultiGesture4DData

    init() {
        recordingData = MultiGesture4DData(Device.Acc_Recording_Buffer_Size, Device.Acc_Threshold_Level, [])// no initial keys
    }

    /**
     *
     * @return
     */
    public func getRecordingData() -> MultiGesture4DData {
        return recordingData
    }
    
    
    /**
     *
     * @return
     */
    public func getKeys() -> [String]? {
        return recordingData.getKeys()
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
    public func deleteGesture(_ key: String?) {
        if key == nil {
            return
        }

        recordingData.delete(key!)
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
}

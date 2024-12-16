//
//  GestureData3DStore.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class GestureData3DStore {
    private var mDataChangeListener: DataChangeListener?
    private var recordingData: GestureData3D?
    private var testingData: GestureData3D?
    private var gestureCorrelationData: GestureCorrelationData?

    init() {
        self.recordingData = GApp2.GestureData3D(100)
        self.testingData = GApp2.GestureData3D(100)
        self.gestureCorrelationData = GApp2.GestureCorrelationData(recordingData, testingData)

    }

    /**
     * @param dataChangeListener
     */
    public func setChangeListener(_ dataChangeListener: DataChangeListener) {
        mDataChangeListener = dataChangeListener
    }

    /**
     * @param x
     * @param y
     * @param z
     */
    public func addForRecording(_ x: Double, _ y: Double, _ z: Double) {
        recordingData?.add(x, y, z)
        notifyRecordingDataChanged()
    }

    /**
     * @param x
     * @param y
     * @param z
     */
    public func addForTesting(_ x: Double, _ y: Double, _ z: Double) {
        testingData?.add(x, y, z)
        notifyTestDataChanged()
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    public func addForRealtimeTesting(_ x: Double, _ y: Double, _ z: Double) {
        //realtimeScanner.eval(x, y, z);
    }

    /**
     *
     */
    public func clearTesting() {
        testingData?.clear()
        gestureCorrelationData?.invalidate()
    }

    /**
     *
     */
    public func clearRecording() {
        recordingData?.clear()
        gestureCorrelationData?.invalidate()
    }

    /**
     * @return
     */
    public func getRecordingData() -> GestureData3D? {
        return recordingData
    }

    /**
     * @return
     */
    public func getTestingData() -> GestureData3D? {
        return testingData
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
     */
    public func getPointer() -> Int {
        if recordingData == nil || testingData == nil {
            return 0
        }
        //TODO ... maybe split in recording and testing pointers
        return min(recordingData!.getPointer(), testingData!.getPointer())
    }

    /**
     *
     */
    public func getCapacity() -> Int {
        if recordingData == nil || testingData == nil {
            return 0
        }

        return max(recordingData!.getCapacity(), testingData!.getCapacity())
    }

    /**
     *
     */

    public func getInvWindowCorrelation() -> [Double]? {
        return gestureCorrelationData?.getInvWindowCorrelation()
    }

    /**
     *
     * @return
     */
    public func getRecordingSignalBase() -> BaseSignalProp3D? {
        return gestureCorrelationData?.getRecordingSignalBase()
    }

    /**
     *
     * @return
     */
    public func getTestingSignalBase() -> BaseSignalProp3D? {
        return gestureCorrelationData?.getTestingSignalBase()
    }

    /**
     *
     * @return
     */
    public func getWindowsCorrelationFactor() -> Double {
        if gestureCorrelationData == nil {
            return 0.0
        }
        return gestureCorrelationData!.getWindowsCorrelationFactor()
    }
}

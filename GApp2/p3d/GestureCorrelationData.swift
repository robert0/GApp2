//
//  GestureCorrelationData.swift
//  GApp
//
//  Created by Robert Talianu
//

public class GestureCorrelationData {
    var xcorr: [Double]? = nil
    var invXCorr: [Double]? = nil
    var xTestNormToRecording: [Double]? = nil
    var rec_base: BaseSignalProp3D? = nil
    var tst_base: BaseSignalProp3D? = nil
    var windowCorrelation: [Double]? = nil
    var invWindowCorrelation: [Double]? = nil
    var corrWindowFactor: Double = 0.0
    var recordingData: GestureData3D? = nil
    var testingData: GestureData3D? = nil

    /**
     *
     * @param recordingData
     * @param testingData
     */
    init(_ recordingData: GestureData3D?, _ testingData: GestureData3D?) {
        self.recordingData = recordingData
        self.testingData = testingData
    }

    /**
     *
     * @return
     */
    public func invalidate() {
        xcorr = nil
        invXCorr = nil
        xTestNormToRecording = nil
        corrWindowFactor = 0.0
        rec_base = nil
        tst_base = nil
        windowCorrelation = nil
        invWindowCorrelation = nil
    }

    private func build() {
        if getRecordingData()!.getCapacity() == getRecordingData()!.getData().count && getTestingData()!.getCapacity() == getTestingData()!.getData().count {

            let r_norm = ArrayMath3D.normalizeToNew(getRecordingData()!.getData(), 1.0)
            let t_norm = ArrayMath3D.normalizeToNew(getTestingData()!.getData(), 1.0)

            rec_base = ArrayMath3D.extractBaseAboveLevelFactor(r_norm, 0.2, false)
            tst_base = ArrayMath3D.extractBaseAboveLevelFactor(t_norm, 0.2, false)

            windowCorrelation = ArrayMath3D.phasedCorrelation(rec_base!.getBase(), t_norm)
            invWindowCorrelation = windowCorrelation!.map({ 0.0 - $0 })

            self.corrWindowFactor = ArrayMath3D.correlation(rec_base!.getBase(), tst_base!.getBase())
        }
    }

    /**
     *
     * @return
     */
    public func getRecordingData() -> GestureData3D? {
        return recordingData
    }

    /**
     *
     * @return
     */
    public func setRecordingData(_ recordingData: GestureData3D) {
        self.recordingData = recordingData
    }

    /**
     *
     * @return
     */
    public func getTestingData() -> GestureData3D? {
        return testingData
    }

    /**
     *
     * @return
     */
    public func setTestingData(_ testingData: GestureData3D) {
        self.testingData = testingData
    }

    /**
     *
     * @return
     */
    public func getRecordingSignalBase() -> BaseSignalProp3D? {
        if rec_base != nil {
            return rec_base
        }

        build()

        return rec_base
    }

    /**
     *
     * @return
     */
    public func getTestingSignalBase() -> BaseSignalProp3D? {
        if tst_base != nil {
            return tst_base
        }

        build()

        return tst_base
    }

    /**
     *
     * @return
     */
    public func getInvWindowCorrelation() -> [Double]? {
        if invWindowCorrelation != nil {
            return invWindowCorrelation
        }

        build()

        return invWindowCorrelation
    }

    /**
     *
     * @return
     */
    public func getWindowsCorrelationFactor() -> Double {
        return corrWindowFactor
    }
}

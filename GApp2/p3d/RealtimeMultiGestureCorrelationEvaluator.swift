//
//  RealtimeMultiGestureCorrelationEvaluator.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class RealtimeMultiGestureCorrelationEvaluator: RealtimeGestureScanner, GestureScanListener {

    private var referenceData: Multi4DGestureData?
    private var listener: GestureScanListener?
    private var evalListeners:[GestureEvaluationListener] = []

    /**
     *
     * @param multiGestureData
     * @param zeroesThresholdLevel
     */
    init(_ multiGestureData: Multi4DGestureData, _ zeroesThresholdLevel: Double) {
        super.init(zeroesThresholdLevel)
        self.referenceData = multiGestureData
        registerListener(self)
    }

    /**
     *
     * @return
     */
    public func getListener() -> GestureScanListener? {
        return listener
    }

    /**
     *
     * @param
     */
    public func setListener(_ listener: GestureScanListener) {
        self.listener = listener
    }

    /**
     *
     * @param evalListener
     */
    public func addEvaluationListener(_ evalListener: GestureEvaluationListener){
        self.evalListeners.append(evalListener);
    }
    
    /**
     *
     * @return
     */
    public func getReferenceGesturesData() -> Multi4DGestureData? {
        return referenceData
    }

    /**
     *
     * @param referenceGestures
     */
    public func setReferenceGestures(_ referenceGestures: Multi4DGestureData) {
        self.referenceData = referenceGestures
    }

    /**
     *
     */
    public func gestureStarted() {
        self.listener?.gestureStarted()
    }

    /**
     *
     */
    public func gestureEnded() {
        self.listener?.gestureEnded()
    }

    /**
     *
     */
    public func zeroesStarted() {
        self.listener?.zeroesStarted()
    }

    /**
     *
     */
    public func zeroesEnded() {
        self.listener?.zeroesEnded()
    }

    /**
     *
     */
    public func gestureContinuation() {
        var gw = getGestureWindow()
        var gtime = gw.getTimeLength()
        if gtime == 0 {
            return
        }

        if referenceData == nil || referenceData!.getKeys().count == 0 {
            return
        }

        //only check the signals if the span is the same
        for gkey in referenceData!.getKeys() {
            var gBase = referenceData!.getBase(gkey)
            if gBase != nil && gw.getSamples().count == gBase!.getBase().count {
                notifyGestureEvaluated(gBase!, gw, checkCorrelation(gw, gBase!))
            }
        }

        self.listener?.gestureContinuation()
    }

    /**
     *
     * @param gbase
     * @param gw
     * @param status
     */
    private func notifyGestureEvaluated(_ gbase: BaseSignalProp4D, _ gw: GestureWindow, _ status: GestureEvaluationStatus) {
        for listener in self.evalListeners {//TODO check for thread safe access to evalListeners
            listener.gestureEvaluationCompleted(gw, status)
        }
    }

    /**
     *
     * @param gw
     * @param gbase
     */
    private func checkCorrelation(_ gw: GestureWindow, _ gbase: BaseSignalProp4D) -> GestureEvaluationStatus {
        //TODO... should we normalize the data before correlation?
        //List<Sample3D> r_norm = ArrayMath3D.normalizeToNew(getRecordingData().getData(), 1.0f);
        //List<Sample3D> t_norm = ArrayMath3D.normalizeToNew(getTestingData().getData(), 1.0f);
        let corelationFactor = ArrayMath4D.correlation(gbase.getBase(), gw.getSamples())
        return GestureEvaluationStatus(gbase.getKey(), corelationFactor)
    }

}

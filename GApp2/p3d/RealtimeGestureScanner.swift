//
//  RealtimeGestureScanner.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class RealtimeGestureScanner {
    private var listener: GestureScanListener?
    private var zeroesThresholdLevel: Double = 1.0
    private var isGestureStarted: Bool = false
    private var lastSample: Sample5D? = nil
    private var lastZeroesWindow: ZeroesWindow = ZeroesWindow(Int64(1000 * Device.Acc_Testing_Gesture_Leading_Zeroes_Time_Interval))
    private var gestureWindow: GestureWindow = GestureWindow(Device.Acc_Recording_Buffer_Size)
    private var prevGestureWindow: GestureWindow = GestureWindow(Device.Acc_Recording_Buffer_Size)

    private var signalBuffer = RollingQueue<Sample5D>(Device.Acc_Recording_Buffer_Size)

    /**
     * @param zeroesThresholdLevel
     */
    init(_ zeroesThresholdLevel: Double) {
        self.zeroesThresholdLevel = zeroesThresholdLevel
    }

    /**
     * //TODO... only use one listener for now; expand it later if needed
     *
     * @param listener
     */
    public func registerListener(_ listener: GestureScanListener) {
        //TODO... only use one listener for now; expand it later if needed
        self.listener = listener
    }

    /**
     *
     * @return
     */
    public func getLastZeroesWindow() -> ZeroesWindow {
        return lastZeroesWindow
    }

    /**
     *
     * @return
     */
    public func getGestureWindow() -> GestureWindow {
        return gestureWindow
    }

    /**
     * @param x
     * @param y
     * @param z
     * @param time
     */
    public func eval(_ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        //eval if current sample is part of signal
        if isGesture(x, y, z) {
            //mark down the gesture start
            markGesture(x, y, z, time)
        } else {
            // mark down the next zero
            markZero(x, y, z, time)
        }
        self.signalBuffer.add(Sample5D(lastSample!))
    }

    // true if any (x,y) lvl above ref level
    private func isGesture(_ x: Double, _ y: Double, _ z: Double) -> Bool {
        return x > zeroesThresholdLevel || -x > zeroesThresholdLevel || y > zeroesThresholdLevel || -y > zeroesThresholdLevel
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     * @param time
     */
    private func markGesture(_ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        if lastSample != nil {
            if lastSample!.getType() == 0 && lastZeroesWindow.isReference() && !isGestureStarted {
                if gestureWindow.getSamples().count > 1 {
                    prevGestureWindow.from(gestureWindow)
                }
                gestureWindow.clear()
                gestureWindow.add(x, y, z, time)
                isGestureStarted = true
                notifyZeroesEnded()
                notifyGestureStarted()
            } else {
                gestureWindow.add(x, y, z, time)  //add starting point
                notifyGestureContinuation()
            }
            lastSample!.setFrom(x, y, z, time, 1)

        } else {
            lastSample = Sample5D(x, y, z, time, 1)
        }
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     * @param time
     */
    public func markZero(_ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        if lastSample != nil {
            if lastSample!.getType() == 1 {
                lastZeroesWindow.setFrom(Sample4D(x, y, z, time), Sample4D(x, y, z, time))
                if isGestureStarted {
                    gestureWindow.add(Sample4D(x, y, z, time))
                    notifyGestureContinuation()
                }
                notifyZeroesStarted()

            } else if lastSample!.getType() == 0 {
                self.lastZeroesWindow.setEnd(Sample4D(x, y, z, time))
                if isGestureStarted {
                    gestureWindow.add(Sample4D(x, y, z, time))
                    notifyGestureContinuation()
                }
                if lastZeroesWindow.isReference() && isGestureStarted {
                    isGestureStarted = false
                    trimGesture()
                    notifyGestureEnded()
                    if gestureWindow.getSamples().count > 1 {
                        prevGestureWindow.from(gestureWindow)
                    }
                    gestureWindow.clear()
                }
            }
            lastSample!.setFrom(x, y, z, time, 0)

        } else {
            //the very first zero sample
            lastZeroesWindow.setFrom(nil)
            lastZeroesWindow.setStart(Sample4D(x, y, z, time))
            lastSample = Sample5D(x, y, z, time, 0)
        }
    }

    private func notifyGestureStarted() {
        if self.listener != nil {
            self.listener!.gestureStarted()
        }
    }

    private func notifyGestureEnded() {
        self.listener?.gestureEnded()
    }

    private func notifyGestureContinuation() {
        self.listener?.gestureContinuation()
    }

    private func notifyZeroesStarted() {
        self.listener?.zeroesStarted()
    }

    private func notifyZeroesEnded() {
        self.listener?.zeroesEnded()
    }

    /**
     * remove the zeroes from the end
     */
    private func trimGesture() {
    }

    /**
     *
     * @return
     */
    public func getPreviousGesture() -> GestureWindow {
        return prevGestureWindow
    }

    /**
     *
     * @return
     */
    public func getDataBuffer() -> RollingQueue<Sample5D> {
        return signalBuffer
    }

}

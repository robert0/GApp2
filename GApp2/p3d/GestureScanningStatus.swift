//
//  GestureScanningStatus.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class GestureScanningStatus {

    private var isGestureStarted: Bool = false
    private var lastSample: Sample5D?
    private var lastZeroesWindow: ZeroesWindow = ZeroesWindow(Int64(1000 * Device.Acc_Testing_Gesture_Leading_Zeroes_Time_Interval))
    private var gestureWindow: GestureWindow = GestureWindow(Device.Acc_Recording_Buffer_Size)

    /**
     *
     * @param x
     * @param y
     * @param z
     * @param time
     */
    public func markGesture(
        _ x: Double, _ y: Double, _ z: Double, _ time: Int64
    ) {
        if (lastSample != nil) {
            if lastSample!.getType() == 0 && lastZeroesWindow.isReference() {
                //first gesture mark with a reference zeroes and previous zero sample will start a new gesture
                gestureWindow.clear()
                gestureWindow.add(x, y, z, time)
                isGestureStarted = true
                notifyGestureStarted()

            } else {
                gestureWindow.add(x, y, z, time)  //add starting point
                notifyGestureContinuation()
            }
        } else {
            lastSample = Sample5D(x, y, z, time, 1)
        }
    }

    /**
     * @return
     */
    private func notifyGestureStarted() {
    }

    /**
     * @return
     */
    private func notifyGestureEnded() {

    }

    /**
     * @return
     */
    private func notifyGestureContinuation() {

    }

    /**
     *
     * @param x
     * @param y
     * @param z
     * @param time
     */
    public func markZero(_ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        if (lastSample != nil) {
            if lastSample!.getType() == 1 {
                lastZeroesWindow.setFrom(
                    Sample4D(x, y, z, time), Sample4D(x, y, z, time))
                if isGestureStarted {
                    gestureWindow.add(Sample4D(x, y, z, time))
                    notifyGestureContinuation()
                }
                notifyZeroesStarted()

            } else if (lastSample!.getType() == 0) {
                lastZeroesWindow.setEnd(Sample4D(x, y, z, time))
                if isGestureStarted {
                    gestureWindow.add(Sample4D(x, y, z, time))
                    notifyGestureContinuation()
                }
                if lastZeroesWindow.isReference() && isGestureStarted {
                    isGestureStarted = false
                    trimGesture()
                    notifyGestureEnded()
                    gestureWindow.clear()
                }
            }
            lastSample!.setFrom(x, y, z, time, 0)

        } else {
            lastZeroesWindow.setStart(Sample4D(x, y, z, time))
            lastSample = Sample5D(x, y, z, time, 0)
        }
    }

    /**
     * remove the zeroes from the end
     */
    private func trimGesture() {

    }

    private func notifyZeroesStarted() {
    }
}

//
//  GestureWindow.swift
//  GApp
//
//  Created by Robert Talianu
//

public class GestureWindow {
    private var samples: [Sample4D]

    /**
     *  Constructor
     */
    init(_ initialCapacity: Int) {
        samples = []
    }

    /**
     *
     * @return
     */
    public func getSamples() -> [Sample4D] {
        return samples
    }

    /**
     *
     * @return
     */
    public func setSamples(_ samples: [Sample4D]) {
        self.samples = samples
    }

    /**
     *
     * @return
     */
    public func getFirstSample() -> Sample4D? {
        return samples.first
    }

    /**
     * @return
     */
    public func getLastSample() -> Sample4D? {
        return samples.last
    }

    /**
     * @return
     */
    public func clear() {
        samples.removeAll()
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     * @param time
     */
    public func add(_ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        samples.append(Sample4D(x, y, z, time))
    }

    /**
     *
     * @param sample
     */
    public func add(_ sample: Sample4D) {
        samples.append(sample)
    }

    /**
     *
     * @return
     */
    public func getTimeLength() -> Int64 {
        if samples.isEmpty || samples.count == 1 {
            return 0
        }

        var start = samples.first
        var end = samples.last
        if start == nil || end == nil {
            return 0
        }

        return end!.getTime() - start!.getTime()
    }

    /**
     *
     * @return
     */
    public func from(_ gestureWindow: GestureWindow) {
        samples.removeAll()
        samples = Array(gestureWindow.samples)
    }

}

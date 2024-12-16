//
//  ZeroesWindow.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class ZeroesWindow {

    private var refTime: Int64 = 0

    private var start: Sample4D?
    private var end: Sample4D?

    /**
     *
     * @constructor
     */
    init(_ refTime: Int64) {
        self.refTime = refTime
    }

    /**
     *
     */
    public func getStart() -> Sample4D? {
        return start
    }

    /**
     *
     */
    public func setStart(_ start: Sample4D) {
        self.start = start
    }

    /**
     *
     */
    public func getEnd() -> Sample4D? {
        return end
    }

    /**
     *
     */
    public func setEnd(_ end: Sample4D) {
        self.end = end
    }

    /**
     *
     * @param w
     */
    public func setFrom(_ w: ZeroesWindow?) {
        if w == nil {
            self.start = nil
            self.end = nil
        } else {
            self.start = w!.getStart()
            self.end = w!.getEnd()
        }
    }

    /**
     *
     * @param start
     * @param end
     */
    public func setFrom(_ start: Sample4D, _ end: Sample4D) {
        self.start = start
        self.end = end
    }

    /**
     *
     * @return
     */
    public func isReference() -> Bool {
        if getEnd() == nil || getStart() == nil {
            return false
        }
        return getEnd()!.getTime() - getStart()!.getTime() > self.refTime
    }
}

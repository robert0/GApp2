//
//  BaseSignalProp4D.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class BaseSignalProp4D {

    private var startIndex: Int = 0
    private var endIndex: Int = 0
    private var level: Double = 0
    private var originalSignalLength: Int = 0
    private var base: [Sample4D] = []

    private var key: String = ""

    /**
     *
     */
    init() {
        // TODO Auto-generated constructor stub
    }

    /**
     */
    public func getOriginalSignalLength() -> Int {
        return self.originalSignalLength

    }

    /**
     */
    public func setOriginalSignalLength(_ originalSignalLength: Int) {
        self.originalSignalLength = originalSignalLength
    }

    /**
     */
    public func getLevel() -> Double {
        return self.level
    }

    /**
     */
    public func setLevel(_ level: Double) {
        self.level = level
    }

    /**
     */
    public func getStartIndex() -> Int {
        return self.startIndex
    }

    /**
     */
    public func setStartIndex(_ startIndex: Int) {
        self.startIndex = startIndex
    }

    /**
     */
    public func getEndIndex() -> Int {
        return self.endIndex
    }

    /**
     */
    public func setEndIndex(_ endIndex: Int) {
        self.endIndex = endIndex
    }

    /**
     */
    public func getBase() -> [Sample4D] {
        return self.base
    }

    /**
     */
    public func setBase(_ base: [Sample4D]) {
        self.base = base
    }

    /**
     * @return
     */
    public func getKey() -> String {
        return key
    }

    /**
     * @param key
     */
    public func setKey(_ key: String) {
        self.key = key
    }

    /**
     * @return
     */
    public func getTimeLength() -> Int64 {
        if base.count == 0 || base.count == 1 {
            return 0
        }

        var start = base[0]
        var end = base[base.count - 1]
        return end.getTime() - start.getTime()
    }
}

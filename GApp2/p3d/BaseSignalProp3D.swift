//
//  BaseSignalProp3D.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class BaseSignalProp3D {
    private var startIndex: Int = 0
    private var endIndex: Int = 0
    private var level: Double = 0
    private var originalSignalLength: Int = 0
    private var base: [Sample3D] = []

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
    public func getBase() -> [Sample3D] {
        return self.base
    }

    /**
     */
    public func setBase(_ base: [Sample3D]) {
        self.base = base
    }
}

//
//  BaseSignalProp.swift
//  GApp
//
//  Created by Robert Talianu
//

/// @param <T>
public class BaseSignalProp<T> {
    private var startIndex: Int = 0
    private var endIndex: Int = 0
    private var levelFactor: Double = 0.0

    private var originalSignalLength: Int = 0

    private var base: [T] = []

    /**
	 * @return
	 */
    public func getOriginalSignalLength() -> Int {
        return originalSignalLength
    }

    /**
	 * @param originalSignalLength
	 */
    public func setOriginalSignalLength(_ originalSignalLength: Int) {
        self.originalSignalLength = originalSignalLength
    }

    /**
	 * @return
	 */
    public func getLevelFactor() -> Double {
        return levelFactor
    }

    /**
	 * @param levelFactor
	 */
    public func setLevelFactor(_ levelFactor: Double) {
        self.levelFactor = levelFactor
    }

    /**
	 * @return
	 */
    public func getStartIndex() -> Int {
        return startIndex
    }

    /**
	 * @param startIndex
	 */
    public func setStartIndex(_ startIndex: Int) {
        self.startIndex = startIndex
    }

    /**
	 * @return
	 */
    public func getEndIndex() -> Int {
        return endIndex
    }

    /**
	 * @param endIndex
	 */
    public func setEndIndex(_ endIndex: Int) {
        self.endIndex = endIndex
    }

    /**
	 * @return
	 */
    public func getBase() -> [T] {
        return base
    }

    /**
	 * @param base
	 */
    public func setBase(_ base: [T]) {
        self.base = base
    }
}

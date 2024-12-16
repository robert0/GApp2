//
//  DataStream.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public protocol DataStream {

    /**
	 * @param dataChangeListener
	 */
    func setChangeListener(_ dataChangeListener: DataChangeListener)

    /**
	 * @param value
	 */
    func addX(_ value: Double)

    /**
	 * @param value
	 */
    func addY(_ value: Double)

    /**
	 * @param value
	 */
    func addZ(_ value: Double)

    /**
	 * @return
	 */
    func getXData() -> [Double]

    /**
	 * @return
	 */
    func getYData() -> [Double]

    /**
	 * @return
	 */
    func getZData() -> [Double]

    /**
	 * @return
	 */
    func getMin() -> Double

    /**
	 * @return
	 */
    func getMax() -> Double

    /**
	 * @return
	 */
    func getRange() -> Double
}

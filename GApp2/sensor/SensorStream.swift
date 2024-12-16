//
//  SensorStream.swift
//  GApp
//
//  Created by Robert Talianu
//

public class SensorStream {

    var mXData: [Double] = []
    var mYData: [Double] = []
    var mZData: [Double] = []

    private var mMin: Double = 0.0
    private var mMax: Double = 0.0

    var mDataChangeListener: DataChangeListener?

    init(_ size: Int, _ min: Double, _ max: Double) {
        mMin = min
        mMax = max
    }

    /**
     * @param dataChangeListener
     */
    public func setChangeListener(_ dataChangeListener: DataChangeListener) {
        self.mDataChangeListener = dataChangeListener
    }

    /**
     * @param value
     */
    public func addX(_ value: Double) {
        //TODO ...
        //        System.arraycopy(mXData, 1, mXData, 0, mXData.length - 1);
        //        mXData[mXData.length - 1] = value;
        //
        mDataChangeListener?.onDataChange(0)
    }

    /**
     * @param value
     */
    public func addY(_ value: Double) {
        //TODO ...
        //        System.arraycopy(mYData, 1, mYData, 0, mYData.length - 1);
        //        mYData[mYData.length - 1] = value;
        mDataChangeListener?.onDataChange(0)
    }

    /**
     * @param value
     */
    public func addZ(_ value: Double) {
        //TODO ...
        //        System.arraycopy(mYData, 1, mYData, 0, mYData.length - 1);
        //        mYData[mYData.length - 1] = value;
        mDataChangeListener?.onDataChange(0)
    }

    /**
     * @return
     */
    public func getXData() -> [Double] {
        return mXData
    }

    /**
     * @return
     */
    public func getYData() -> [Double] {
        return mYData
    }

    /**
     * @return
     */
    public func getZData() -> [Double] {
        return mZData
    }

    /**
     * @return
     */
    func getMin() -> Double {
        return mMin
    }

    /**
     * @return
     */
    public func getMax() -> Double {
        return mMax
    }

    /**
     * @return
     */
    public func getRange() -> Double {
        return (mMax - mMin)
    }
}

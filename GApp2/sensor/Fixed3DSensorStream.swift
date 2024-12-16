//
//  Fixed3DSensorStream.swift
//  GApp
//
//  Created by Robert Talianu
//



public class Fixed3DSensorStream : SensorStream {

    private var counter:Int = 0;

    override init(_ size:Int, _ min:Double, _ max:Double) {
        super.init(size, min, max);
    }


    public func reset() {
        self.counter = 0;
    }

    public func getCounter() -> Int{
        return self.counter;
    }

    /**
     *
     * @param valueX
     * @param valueY
     * @param valueZ
     */
    public func addEntry(_ valueX:Double, _ valueY:Double, _ valueZ:Double) {
        if (counter >= mXData.count) {
            //counter = 0;
            return;
        }
        mXData[counter] = valueX;
        mYData[counter] = valueY;
        mZData[counter] = valueZ;
        counter+=1
        mDataChangeListener?.onDataChange(0);
    }
}

//
//  Sample5D.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class Sample5D: Sample4D {
    public var type: Int = 0

    /**
     * @param x
     * @param y
     * @param z
     * @param time
     * @param type
     */
    init(_ x: Double, _ y: Double, _ z: Double, _ time: Int64, _ type: Int) {
        super.init(x, y, z, time)
        self.type = type
    }

    /**
     * @param x
     */
    init(_ sample: Sample5D) {
        super.init(sample.x, sample.y, sample.z, sample.time)
        self.type = sample.type
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    /**
     * @param x
     * @param y
     * @param z
     * @param time
     * @param type
     */
    public func setFrom(_ x: Double, _ y: Double, _ z: Double, _ time: Int64, _ type: Int) {
        self.x = x
        self.y = y
        self.z = z
        self.time = time
        self.type = type
    }

    /**
     *
     * @return
     */
    public func getType() -> Int {
        return self.type
    }

    //function to serialize to json
    override public func toJSON() -> String {
        return "{x:\(x), y:\(y), z:\(z), time:\(time), type:\(type)}"
    }
    
    //function to serialize to json
    override public func toJSON(_ numbersDecimalPlaces: Int) -> String {
        let xx = x.formatted(.number.precision(.fractionLength(numbersDecimalPlaces)))
        let yy = y.formatted(.number.precision(.fractionLength(numbersDecimalPlaces)))
        let zz = z.formatted(.number.precision(.fractionLength(numbersDecimalPlaces)))
        return "{x:\(xx), y:\(yy), z:\(zz), time:\(time), type:\(type)}"
    }
}

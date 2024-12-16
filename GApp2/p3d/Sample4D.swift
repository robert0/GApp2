//
//  Sample4D.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class Sample4D: Sample3D {
    public var time: Int64 = 0

    /**
     *
     * @return
     */
    init(_ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        super.init(x, y, z)
        self.time = time
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    /**
     *
     * @return
     */
    public func getTime() -> Int64 {
        return self.time
    }
    
    //function to serialize to json
    override public func toJSON() -> String {
        return "{x:\(x), y:\(y), z:\(z), time:\(time)}"
    }
    
    //function to serialize to json
    override public func toJSON(_ numbersDecimalPlaces: Int) -> String {
        let xx = x.formatted(.number.precision(.fractionLength(numbersDecimalPlaces)))
        let yy = y.formatted(.number.precision(.fractionLength(numbersDecimalPlaces)))
        let zz = z.formatted(.number.precision(.fractionLength(numbersDecimalPlaces)))
        return "{x:\(xx), y:\(yy), z:\(zz), time:\(time)}"
    }
}

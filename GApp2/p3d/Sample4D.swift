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
    
    enum ConfigKeys4: String, CodingKey {
        case time
    }
    
    /**
     *
     * @return
     */
    public init(_ x: Double, _ y: Double, _ z: Double, _ time: Int64) {
        super.init(x, y, z)
        self.time = time
    }
    
    /**
     * JSON decoder
     * @return
     */
    required public init(from decoder: any Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: ConfigKeys4.self)
        self.time = try values.decodeIfPresent(Int64.self, forKey: .time)!
    }
    
    
    /**
     * JSON encoder
     * @param encoder
     */
    public override func encode(to encoder: any Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: ConfigKeys4.self)
        try container.encode(time, forKey: .time)
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

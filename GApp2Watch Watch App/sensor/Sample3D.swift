//
//  Sample3D.swift
//  GApp2
//
//  Created by Robert Talianu
//

public class Sample3D: JSONAble, Codable {

    public var x: Double = 0.0
    public var y: Double = 0.0
    public var z: Double = 0.0
    
    public enum ConfigKeys: String, CodingKey {
        case x
        case y
        case z
    }
    
    /**
     */
    init(){
        //nothing
    }
    
    /**
     * @param x
     * @param y
     * @param z
     */
    init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    /**
     * @param decoder
     */
    public required init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.x = try values.decodeIfPresent(Double.self, forKey: .x)!
        self.y = try values.decodeIfPresent(Double.self, forKey: .y)!
        self.z = try values.decodeIfPresent(Double.self, forKey: .z)!
    }
    
    /**
     * @param encoder
     */
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: ConfigKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(z, forKey: .z)
    }
    
    public func getX() -> Double {
        return x
    }

    public func getY() -> Double {
        return y
    }

    public func getZ() -> Double {
        return z
    }

    public func setX(_ x: Double) {
        self.x = x
    }

    public func setY(_ y: Double) {
        self.y = y
    }

    public func setZ(_ z: Double) {
        self.z = z
    }

    /**
     * case 0:
     *      return x;
     * case 1:
     *      return y;
     * case 2:
     *      return z;
     *
     * @param index
     * @return
     */
    public func getByIndex(_ index: Int) -> Double {
        switch index {
        case 0:
            return x
        case 1:
            return y
        case 2:
            return z
        default:
            return 0.0
        }
    }
    
    //function to serialize to json
    public func toJSON() -> String {
        return "{x:\(x), y:\(y), z:\(z)}"
    }
    
    //function to serialize to json
    public func toJSON(_ numbersDecimalPlaces: Int) -> String {
        let xx = x.formatted(.number.precision(.fractionLength(numbersDecimalPlaces)))
        let yy = y.formatted(.number.precision(.fractionLength(numbersDecimalPlaces)))
        let zz = z.formatted(.number.precision(.fractionLength(numbersDecimalPlaces)))
        return "{x:\(xx), y:\(yy), z:\(zz)}"
    }
    
}

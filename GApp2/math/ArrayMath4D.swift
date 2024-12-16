//
//  ArrayMath4D.swift
//  GApp
//
//  Created by Robert Talianu
//
import Foundation

public class ArrayMath4D {

    /**
     *
     * @param signal
     * @param absMaxNorm
     * @return
     */
    public static func normalizeToNew(_ signal: [Sample4D], _ absMaxNorm: Double)  -> [Sample4D] {
        var maxVx: Double = signal.map { abs($0.x) }.max() ?? 0.0
        var maxVy: Double = signal.map { abs($0.y) }.max() ?? 0.0
        var maxTotAbs: Double = max(maxVx, maxVy)

        var factor: Double = absMaxNorm / maxTotAbs
        var result: [Sample4D] = signal.map {
            Sample4D($0.x * factor, $0.y * factor, $0.z * factor, $0.time)
        }

        return result
    }

    /**
     *
     * @param signal
     * @param levelFactor
     * @param isCartesianProduct
     * @return
     */
    public static func extractBaseAboveLevelFactor( _ signal: [Sample4D], _ levelFactor: Double, _ isCartesianProduct: Bool) -> BaseSignalProp4D {
        return isCartesianProduct
            ? extractBaseAboveLevelFactorCartesian(signal, levelFactor)
            : extractBaseAboveLevelFactorSum(signal, levelFactor)
    }

    /**
     *
     * @param signal
     * @param levelFactor
     * @return
     */
    public static func extractBaseAboveLevelFactorSum( _ signal: [Sample4D], _ levelFactor: Double) -> BaseSignalProp4D {
        let bprop = BaseSignalProp4D()
        bprop.setLevel(levelFactor)
        bprop.setOriginalSignalLength(signal.count)

        let maxVx = signal.map { abs($0.x) }.max() ?? 0.0
        let maxVy = signal.map { abs($0.y) }.max() ?? 0.0
        let maxV = max(maxVx, maxVy)

        var beginIndex = 0
        for (i, sp) in signal.enumerated() {
            if sp.x > levelFactor * maxV || sp.x < -levelFactor * maxV
                || sp.y > levelFactor * maxV || sp.y < -levelFactor * maxV
            {
                beginIndex = i
                break
            }
        }

        var endingIndex = signal.count - 1
        for i in stride(from: signal.count - 1, to: 0, by: -1) {
            var sp = signal[i]
            if sp.x > levelFactor * maxV || sp.x < -levelFactor * maxV
                || sp.y > levelFactor * maxV || sp.y < -levelFactor * maxV
            {
                endingIndex = i
                break
            }
        }

        bprop.setStartIndex(beginIndex)
        bprop.setEndIndex(endingIndex)
        bprop.setBase(Array(signal[beginIndex..<endingIndex]))
        return bprop
    }

    
    /**
     *
     * @param signal
     * @param levelFactor
     * @return
     */
    public static func extractBaseAboveLevelFactorCartesian( _ signal: [Sample4D], _ levelFactor: Double) -> BaseSignalProp4D {
        //TODO ...
        return BaseSignalProp4D()
    }

    
    /**
     *
     * @param signal
     * @param level
     * @param isCartesianProduct
     * @return
     */
    public static func extractBaseAboveLevel( _ signal: [Sample4D], _ level: Double, _ isCartesianProduct: Bool) -> BaseSignalProp4D {
        return isCartesianProduct
        ? extractBaseAboveLevelCartesian(signal, level)
            : extractBaseAboveLevelSum(signal, level)
    }
    
    /**
     *
     * @param signal
     * @param level
     * @return
     */
    public static func extractBaseAboveLevelSum(_ signal: [Sample4D], _ level: Double) -> BaseSignalProp4D {
        let bprop = BaseSignalProp4D()
        bprop.setLevel(level)
        bprop.setOriginalSignalLength(signal.count)

        var beginIndex = 0
        for (i, sp) in signal.enumerated() {
            if sp.x > level || sp.x < -level || sp.y > level || sp.y < -level {
                beginIndex = i
                break
            }
        }

        var endIndex = signal.count - 1
        for i in stride(from: signal.count - 1, to: 0, by: -1) {
            let sp = signal[i]
            if sp.x > level || sp.x < -level || sp.y > level || sp.y < -level {
                endIndex = i
                break
            }
        }

        bprop.setStartIndex(beginIndex)
        bprop.setEndIndex(endIndex)
        bprop.setBase(Array(signal[beginIndex..<endIndex]))
        return bprop
    }
    
    /**
     *
     * @param signal
     * @param level
     * @return
     */
    public static func extractBaseAboveLevelCartesian( _ signal: [Sample4D], _ level: Double) -> BaseSignalProp4D {
        return BaseSignalProp4D()
    }

    /**
     *
     * @param base
     * @param data
     * @return
     */
    public static func phasedCorrelation(_ base: [Sample4D], _ data: [Sample4D]) -> [Double] {
        let reLen = data.count - base.count
        var res: [Double] = Array(repeating: 0.0, count: reLen)
        for i in 0..<reLen {
            res[i] = correlationIn(base, data, i)
        }

        return res
    }
    
    /**
     *
     * @param base
     * @param data
     * @return
     */
    public static func correlation(_ base: [Sample4D], _ data: [Sample4D]) -> Double {
        //TODO: check here that arrays are not null, of the same length etc
        return correlationIn(base, data, 0)
    }
    
    /**
     *
     * @param base
     * @param data
     * @param startPos
     * @return
     */
    public static func correlationIn( _ base: [Sample4D], _ data: [Sample4D], _ startPos: Int) -> Double {
        var xsx = 0.0
        var ysx = 0.0
        var xsy = 0.0
        var ysy = 0.0
        var xsxx = 0.0
        var ysxx = 0.0
        var xsyy = 0.0
        var ysyy = 0.0
        var xsxy = 0.0
        var ysxy = 0.0
        let ZERO = Sample3D(0.0, 0.0, 0.0)

        let n = base.count
        for i in 0..<n {
            let basep = base[i]
            let datap = (i + startPos) >= data.count ? ZERO : data[i + startPos]

            let xx = basep.x
            let xy = datap.x

            //first axis
            xsx += xx
            xsy += xy
            xsxx += xx * xx
            xsyy += xy * xy
            xsxy += xx * xy

            //second axis
            let yx = basep.y
            let yy = datap.y

            ysx += yx
            ysy += yy
            ysxx += yx * yx
            ysyy += yy * yy
            ysxy += yx * yy
        }

        // covariation
        let dn: Double = Double(n)

        //first axis
        let xcov = xsxy / dn - xsx * xsy / dn / dn
        let xsigmax = sqrt(xsxx / dn - xsx * xsx / dn / dn)
        let xsigmay = sqrt(xsyy / dn - xsy * xsy / dn / dn)
        let cx = xcov / xsigmax / xsigmay

        //*** second axis
        let ycov = ysxy / dn - ysx * ysy / dn / dn
        let ysigmax = sqrt(ysxx / dn - ysx * ysx / dn / dn)
        let ysigmay = sqrt(ysyy / dn - ysy * ysy / dn / dn)
        let cy = ycov / ysigmax / ysigmay

        return 0.5 * (cx + cy)

    }
}

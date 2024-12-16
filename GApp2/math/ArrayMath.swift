//
//  ArrayMath.swift
//  GApp
//
//  Created by Robert Talianu
//
import Foundation

/**
 *
 */
public class ArrayMath {
    /**
     * Convolves sequences a and b.  The resulting convolution has
     * length a.length+b.length-1.
     */
    public static func conv(_ ax: [Double], _ bx: [Double]) -> [Double] {
        var y: [Double] = [Double](
            repeating: 0.0, count: ax.count + bx.count - 1)
        var a: [Double] = ax
        var b: [Double] = bx

        // make sure that a is the shorter sequence
        if ax.count > bx.count {
            a = bx
            b = ax
        }

        for index in 0..<y.count {
            y[index] = 0
            var start: Int = 0
            if index > a.count - 1 {
                start = index - a.count + 1
            }

            var end: Int = index
            if end > b.count - 1 {
                end = b.count - 1
            }

            for n in start..<end + 1 {
                y[index] += b[n] * a[index - n]
            }

        }
        return y
    }

    /**
     * Computes the cross correlation between sequences a and b.
     */
    public static func xcorr(_ a: [Double], _ b: [Double]) -> [Double] {
        var len: Int = a.count
        if b.count > a.count {
            len = b.count
        }

        return xcorr(a, b, len - 1)
    }

    /**
     * Computes the auto correlation of a.
     */
    public static func xcorr(_ a: [Double]) -> [Double] {
        return xcorr(a, a)
    }

    /**
     * Computes the cross correlation between sequences a and b.
     * maxlag is the maximum lag to
     */
    public static func xcorr(_ a: [Double], _ b: [Double], _ maxlag: Int) -> [Double] {
        var y = [Double](repeating: 0.0, count: 2 * maxlag + 1)

        for lag in stride(from: (b.count - 1), to: -a.count, by: -1) {
            var idx = maxlag - (b.count - 1)
            if idx < 0 {
                continue
            }

            if idx >= y.count {
                break
            }

            var start = 0
            if lag < 0 {
                start = -lag
            }

            var end = a.count - 1
            if end > b.count - lag - 1 {
                end = b.count - lag - 1
            }

            for n in start...end {
                y[idx] += a[n] * b[lag + n]
            }

            idx += 1
        }

        return y
    }

    /**
     * Returns the inner product of a and b.  a and b should be the
     * same length or bad things will happen.
     */
    public static func dot(_ a: [Double], _ b: [Double]) -> Double {
        var y = 0.0

        for x in 0..<a.count {
            y += a[x] * b[x]
        }

        return y
    }

    /**
     * Returns the elementwise product of a and b.  a and b should be
     * the same length or bad things will happen.
     */
    public static func times(_ a: [Double], _ b: [Double]) -> [Double] {
        var y = [Double](repeating: 0.0, count: a.count)

        for x in 0..<y.count {
            y[x] = a[x] * b[x]
        }

        return y
    }

    /**
     * Multiplies each element of a by b.
     */
    public static func times(_ a: [Double], _ b: Double) -> [Double] {
        var y = [Double](repeating: 0.0, count: a.count)

        for x in 0..<y.count {
            y[x] = a[x] * b
        }

        return y
    }

    /**
     * Returns the elementwise quotient of a divided by b (a./b).  a
     * and b should be the same length or bad things will happen.
     */
    public static func rdivide(_ a: [Double], _ b: [Double]) -> [Double] {
        var y = [Double](repeating: 0.0, count: a.count)

        for x in 0..<y.count {
            y[x] = a[x] / b[x]
        }

        return y
    }

    /**
     * Divides each element of a by b.
     */
    public static func rdivide(_ a: [Double], _ b: Double) -> [Double] {
        var y = [Double](repeating: 0.0, count: a.count)

        for x in 0..<y.count {
            y[x] = a[x] / b
        }

        return y
    }

    /**
     * Returns the elementwise sum of a and b.  a and b should be
     * the same length or bad things will happen.
     */
    public static func plus(_ a: [Double], _ b: [Double]) -> [Double] {
        var y = [Double](repeating: 0.0, count: a.count)

        for x in 0..<y.count {
            y[x] = a[x] + b[x]
        }

        return y
    }

    /**
     * Adds b to each element of a.
     */
    public static func plus(_ a: [Double], _ b: Double) -> [Double] {
        var y = [Double](repeating: 0.0, count: a.count)

        for x in 0..<y.count {
            y[x] = a[x] + b
        }

        return y
    }

    /**
     * Returns the elementwise difference of a and b.  a and b should
     * be the same length or bad things will happen.
     */
    public static func minus(_ a: [Double], _ b: [Double]) -> [Double] {
        var y = [Double](repeating: 0.0, count: a.count)

        for x in 0..<y.count {
            y[x] = a[x] - b[x]
        }

        return y
    }

    /**
     * Subtracts b from each element of a (y[x] = a[x]-b).
     */
    public static func minus(_ a: [Double], _ b: Double) -> [Double] {
        var y = [Double](repeating: 0.0, count: a.count)
        for x in 0..<y.count {
            y[x] = a[x] - b
        }
        return y
    }

    /**
     * Subtracts each element of b from a (y[x] = a - b[x]).
     */
    public static func minus(_ a: Double, _ b: [Double]) -> [Double] {
        var y = [Double](repeating: 0.0, count: b.count)
        for x in 0..<y.count {
            y[x] = a - b[x]
        }
        return y
    }

    /**
     * Returns the sum of the contents of a.
     */
    public static func sum(_ a: [Double]) -> Double {
        var y: Double = 0
        for x in 0..<a.count {
            y += a[x]
        }
        return y
    }

    /**
     * Returns the max element of a.
     */
    public static func max(_ a: [Double]) -> Double {
        var y: Double = Double.leastNormalMagnitude
        for x in 0..<a.count {
            if a[x] > y {
                y = a[x]
            }
        }
        return y
    }

    /**
     * Returns a new array where each element is the maximum of a[i]
     * and b.
     */
    public static func max(_ a: [Double], _ b: Double) -> [Double] {
        var y = [Double](repeating: 0.0, count: a.count)
        for x in 0..<y.count {
            if a[x] > b {
                y[x] = a[x]
            } else {
                y[x] = b
            }
        }
        return y
    }

    /**
     * Returns the min element of a.
     */
    public static func min(_ a: [Double]) -> Double? {
        return a.min()
    }

    /**
     * Returns a new array where each element is the minimum of a[i]
     * and b.
     */
    public static func min(_ a: [Double], _ b: Double) -> [Double] {
        var y = [Double](repeating: 0.0, count: a.count)
        for x in 0..<y.count {
            if a[x] < b {
                y[x] = a[x]
            } else {
                y[x] = b
            }
        }
        return y
    }

    /**
     *
     * @param list
     * @param maxNorm
     * @return
     */

    public static func normalizeToNew(_ list: [Double], _ absMaxNorm: Double) -> [Double] {
        var maxV = list.max() ?? 0.0
        var minV = list.min() ?? 0.0
        var factor = absMaxNorm / Double.maximum(abs(maxV), abs(minV))
        var result = list.map({ $0 * factor })
        return result
    }

    /**
     *
     * @param base
     * @param levelFactor - a value between 0 and 1, 1 meaning the max value form the base array, 0 meaning 0.0 value
     * @return
     */
    public static func extractBaseAboveLevel(_ base: [Double], _ levelFactor: Double)
        -> [Double]
    {
        var maxV = base.map({ abs($0) }).max() ?? 0.0
        var beginIndex: Int = 0
        for (index, value) in base.enumerated() {
            if value > levelFactor * maxV || value < -levelFactor * maxV {
                beginIndex = index
                break
            }
        }
        var endIndex: Int = base.count - 1
        for index in stride(from: base.count - 1, through: 0, by: -1) {
            var value = base[index]
            if value > levelFactor * maxV || value < -levelFactor * maxV {
                endIndex = index
                break
            }
        }
        return Array(base[beginIndex..<endIndex])

    }

    /**
    *
     */
    public static func extractBaseAboveLevel(_ signal: [Double], _ levelFactor: Double)
        -> BaseSignalProp<Double>
    {
        var bprop: BaseSignalProp = BaseSignalProp<Double>()
        bprop.setLevelFactor(levelFactor)
        bprop.setOriginalSignalLength(signal.count)

        var maxV: Double = signal.map({ abs($0) }).max() ?? 0.0
        var beginIndex: Int = 0
        for (index, value) in signal.enumerated() {
            if value > levelFactor * maxV || value < -levelFactor * maxV {
                beginIndex = index
                break
            }
        }
        var endIndex: Int = signal.count - 1
        for index in stride(from: signal.count - 1, through: 0, by: -1) {
            var value = signal[index]
            if value > levelFactor * maxV || value < -levelFactor * maxV {
                endIndex = index
                break
            }
        }

        bprop.setStartIndex(beginIndex)
        bprop.setEndIndex(endIndex)
        bprop.setBase(Array(signal[beginIndex..<endIndex]))
        return bprop
    }

    /**
     * Correlation by changing the phase of the base array within the test array
     *
     * @param base
     * @param test
     * @return
     */
    public static func phasedCorrelation(_ base: [Double], _ test: [Double])
        -> [Double]
    {

        var reLen = test.count - base.count
        var res: [Double] = [Double](repeating: 0.0, count: reLen)
        for i in 0..<reLen {
            res[i] = self.correlationIn(base, test, i)
        }

        return res
    }

    /**
     *
     * @param xs
     * @param ys
     * @return
     */
    public static func correlation(_ xs: [Double], _ ys: [Double]) -> Double {
        //TODO: check here that arrays are not null, of the same length etc

        return self.correlationIn(xs, ys, 0)
    }

    /**
     *
     * @param xs
     * @param ys
     * @param startPos
     * @return
     */
    private static func correlationIn(
        _ base: [Double], _ data: [Double], _ startPos: Int
    ) -> Double {
        var sx = 0.0
        var sy = 0.0
        var sxx = 0.0
        var syy = 0.0
        var sxy = 0.0

        var n = base.count
        for i in 0..<n {
            var x = base[i]
            var y = data[i + startPos]

            sx += x
            sy += y
            sxx += x * x
            syy += y * y
            sxy += x * y
        }

        // covariation
        var dn: Double = Double(n)
        var cov = sxy / dn - sx * sy / dn / dn
        // standard error of x
        var sigmax = sqrt(sxx / dn - sx * sx / dn / dn)
        // standard error of y
        var sigmay = sqrt(syy / dn - sy * sy / dn / dn)

        // correlation is just a normalized covariation
        return Double(cov / sigmax / sigmay)
    }

}

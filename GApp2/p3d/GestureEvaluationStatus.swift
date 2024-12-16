//
//  GestureEvaluationStatus.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class GestureEvaluationStatus {
    private var gestureKey: String
    private var gestureCorrelationFactor: Double = 0.0

    private var match: Bool = false

    /**
     *
     * @param gestureKey
     * @param gestureCorrelationFactor
     */
    init(_ gestureKey: String, _ gestureCorrelationFactor: Double) {
        self.gestureKey = gestureKey
        self.gestureCorrelationFactor = gestureCorrelationFactor
    }

    /**
     *
     */
    public func getGestureKey() -> String {
        return gestureKey
    }

    /**
     *
     */
    public func setGestureKey(_ gestureKey: String) {
        self.gestureKey = gestureKey
    }

    /**
     *
     */
    public func getGestureCorrelationFactor() -> Double {
        return gestureCorrelationFactor
    }

    /**
     *
     */
    public func setGestureCorrelationFactor(_ gestureCorrelationFactor: Double)
    {
        self.gestureCorrelationFactor = gestureCorrelationFactor
    }

    /**
     *
     */
    public func isMatching() -> Bool {
        return match
    }

    /**
     *
     */
    public func setMatching(_ matching: Bool) {
        match = matching
    }

    //use Comparable protocol from swift
    public func comparator() {
        //            return new Comparator<GestureEvaluationStatus>() {
        //                @Override
        //                public int compare(GestureEvaluationStatus o1, GestureEvaluationStatus o2) {
        //                    return o1.getGestureKey().compareTo(o2.getGestureKey());
        //                }
        //            };
    }
}

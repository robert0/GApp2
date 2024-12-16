//
//  Utils.swift
//  GApp
//
//  Created by Robert Talianu
//

import Foundation

public class Utils {

    /**
     * @return milliseconds
     */
    public static func getCurrentMillis() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

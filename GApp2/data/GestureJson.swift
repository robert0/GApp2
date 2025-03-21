//
//  GestureJson.swift
//  GMacApp
//
//  Created by Robert Talianu
//

import Foundation


public class GestureJson: Codable {
    
    var gestureKey: String
    var gestureCorrelationFactor: Double
    
    init(_ gestureKey: String, _ gestureCorrelationFactor: Double) {
        self.gestureKey = gestureKey
        self.gestureCorrelationFactor = gestureCorrelationFactor
    }
    
    
}

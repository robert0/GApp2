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
    
    init(gestureKey: String, gestureCorrelationFactor: Double) {
        self.gestureKey = gestureKey
        self.gestureCorrelationFactor = gestureCorrelationFactor
    }
    
    
}

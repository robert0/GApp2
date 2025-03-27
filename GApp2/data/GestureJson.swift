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
    var gestureCommand: String
    
    init(_ gestureKey: String, _ gestureCorrelationFactor: Double, _ gestureCommand: String) {
        self.gestureKey = gestureKey
        self.gestureCorrelationFactor = gestureCorrelationFactor
        self.gestureCommand = gestureCommand
    }
    
    
}

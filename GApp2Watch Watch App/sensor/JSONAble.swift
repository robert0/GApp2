//
//  JSONAble.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

protocol JSONAble {
    func toJSON() -> String
    func toJSON(_ numbersDecimalPlaces: Int) -> String
}

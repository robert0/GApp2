//
//  ListWidget.swift
//  GApp2
//
//  Created by Robert Talianu
//
import SwiftUI

//identifiable item to be used inside list
struct ListWidget: Identifiable {
    public let id = UUID()
    public var key: String
    
    init(_ key:String){
        self.key = key
    }
}

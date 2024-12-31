//
//  Gesture4D.swift
//  GApp2
//
//  Created by Robert Talianu on 30.12.2024.
//

import Foundation

public class Gesture4D {
    private var data:[Sample4D] = []
    private var cmd:String = ""
    private var name:String = ""
    
    public func add(_ x: Double,_ y: Double,_ z: Double,_ time: Int64) {
        data.append(Sample4D(x, y, z, time))
    }
    
    public func getData() -> [Sample4D] {
        return data
    }
    
    public func getName() -> String {
        return name
    }
    
    public func getCommand() -> String {
        return cmd
    }
    
    
    public func setData(_ data: [Sample4D]) {
        self.data = data
    }
    
    
    public func setName(_ name: String) {
        self.name = name
    }
    
    public func setCommand(_ cmd: String) {
        self.cmd = cmd
    }
    
    
    public func size() -> Int {
        return data.count
    }
    
    
    public func removeAll() {
        data.removeAll()
    }
}

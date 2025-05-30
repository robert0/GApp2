//
//  Joke.swift
//  GApp2
//
//  Created by Robert Talianu
//


import Foundation

struct GestureSample: Codable {
    var timestamp: Int64
    var data:[Sample4D] = []
    
    
    public enum ConfigKeys: String, CodingKey {
        case timestamp
        case data
    }
    
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timestamp = try container.decode(Int64.self, forKey: .timestamp)
        self.data = try container.decode([Sample4D].self, forKey: .data)
    }
    
    init (timestamp:Int64, data:[Sample4D]) {
        self.timestamp = timestamp
        self.data = data
    }
}

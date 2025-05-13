//
//  Joke.swift
//  GApp2
//
//  Created by Robert Talianu
//


import Foundation

struct GestureObj: Codable {
    var uuid: String
    var name: String
    var data:[Sample4D] = []
    
    
    public enum ConfigKeys: String, CodingKey {
        case uuid
        case name
        case data
    }
    
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.name = try container.decode(String.self, forKey: .name)
        self.data = try container.decode([Sample4D].self, forKey: .data)
    }
    
    init (  uuid:String, name:String, data:[Sample4D]) {
        self.uuid = uuid
        self.name = name
        self.data = data
    }
}

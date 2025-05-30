//
//  Joke.swift
//  GApp2
//
//  Created by Robert Talianu
//


import Foundation

struct GestureObj: Codable {
    var uuid: String = ""
    var name: String = ""
    var samples:[GestureSample] = []
    
    
    public enum ConfigKeys: String, CodingKey {
        case uuid
        case name
        case samples
    }
    
    init (  uuid:String, name:String, samples:[GestureSample]) {
        self.uuid = uuid
        self.name = name
        self.samples = samples
    }
    
    //decode path
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: ConfigKeys.self)
        self.uuid = try container.decode(String.self, forKey: ConfigKeys.uuid)
        self.name = try container.decode(String.self, forKey: ConfigKeys.name)
        self.samples = try container.decode([GestureSample].self, forKey: ConfigKeys.samples)
    }
    
    //encode path
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: ConfigKeys.self)
//       // try container.encode(uuid, forKey: .uuid)
//        try container.encode(name, forKey: .name)
//        try container.encode(samples, forKey: .samples)
//    }
}

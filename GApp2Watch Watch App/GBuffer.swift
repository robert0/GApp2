//
//  GBuffer.swift
//  GApp2 Watch App
//
//  Created by Robert Talianu
//

import Foundation

public class GBuffer {
    var data: String = ""
    
    /*
     *
     */
    func append(_ string: String) {
        data.append(string)
    }
    
    /*
     *
     */
    func consume() -> String {
        let result: String = data
        data = ""
        return result
    }
    
}

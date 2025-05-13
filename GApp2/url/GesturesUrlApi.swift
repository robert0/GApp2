//
//  File.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

class GesturesUrlApi {
    static let baseURL = "https://xfh3k4ok5l.execute-api.eu-central-1.amazonaws.com/dev"
    static let apiKeyName = "x-api-key"
    static let apiKeyValue = "cf702359-a8ca-45b3-874c-91d84eedd015"
    
    //API formats
    //GET
    static let GET_DEVICES_FORMAT = "%@/devices"
    static let GET_GESTURES_FOR_DEVICE_FORMAT = "%@/devices/%@/gestures"
    //POST
    static let POST_URL_FORMAT = "%@/devices/%@/gestures/%@/data"
    
    
    
    //POST request to send a joke
    static func sendGesturePOST(deviceId:String, gs: GestureObj, completion: @escaping (Result<Bool, Error>) -> ()) {
        let postUrl = URL(string: String(format: POST_URL_FORMAT, baseURL, deviceId, gs.uuid))!
        var request = URLRequest(url: postUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKeyValue, forHTTPHeaderField:apiKeyName)
        
        do {
            let jsonData = try JSONEncoder().encode(gs)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        debugRequest(request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    
    ///
    /// - Parameters:   request: URLRequest
    /// - Returns:       Void
    ///
    static func debugRequest(_ request: URLRequest){
        print("---- DEBUG HTTP REQUEST ----")
        print("\(request.httpMethod ?? "") \(request.url)")
        let str = String(decoding: request.httpBody!, as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(request.allHTTPHeaderFields)")
    }
}

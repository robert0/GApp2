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
    /// {
    ///    "deviceId": "788B068A-64EA-49A7-855E-21D66AE76439",
    ///    "gestureIds": [
    ///        "105C1C3D-47C4-4AA1-B543-135F02A4500E",
    ///        "2FC0BD53-ECC4-4AA9-A7F7-8CEE454F08C5",
    ///        "3A1F4029-EB8A-4339-B341-BA18B53FF8F1",
    ///        "4D8D37C3-0676-41B0-A136-DC416DA372B0"
    ///    ],
    ///    "gestureCount": 4
    ///}
    static func getDevices(completion:@escaping (NSObject) -> ()) {
        let getUrl = URL(string: String(format: GET_DEVICES_FORMAT, baseURL))!
    //TODO ...
    //        URLSession.shared.dataTask(with: getUrl) { data,_,_  in
    //            let devices = try! JSONDecoder().decode(DevicesList.self, from: data!)
    //
    ////            DispatchQueue.main.async {
    ////                completion(joke)
    ////            }
    //        }
    //        .resume()
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

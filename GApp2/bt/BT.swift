//
//  BT.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation
import CoreBluetooth

class BT {
    
    public static let ServiceUUID = CBUUID(string: "0000FFF0-0000-1000-2000-300040005000")
    public static let CharacteristicUUID = CBUUID(string: "0000FFF0-0000-1000-2000-300040005001")
    public static let hidReportUUID = CBUUID(string: "2A4D")
    //public static let mouseInputReportUUID = CBUUID(string: "2A4D") - similar UID to keyboard report, so we will use only one uuid for both
    
    /**
     * Decode Data to Object
     * @param data Data to decode
     * @return Object of type T
     * @throws DecodingError if the data cannot be decoded to the specified type
     * @throws Error if the data is nil or cannot be decoded
     */
    public static func decodeDataToObject<T: Codable>(data : Data?)->T?{
        
        if let dt = data{
            do{
                
                return try JSONDecoder().decode(T.self, from: dt)
                
            }  catch let DecodingError.dataCorrupted(context) {
                Globals.logToScreen("JSON " + context.debugDescription)
                
            } catch let DecodingError.keyNotFound(key, context) {
                Globals.logToScreen("JSON - Key '\(key)' not found:" + context.debugDescription)
                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
                
            } catch let DecodingError.valueNotFound(value, context) {
                Globals.logToScreen("JSON - Value '\(value)' not found:" + context.debugDescription)
                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
                
            } catch let DecodingError.typeMismatch(type, context)  {
                Globals.logToScreen("JSON - Type '\(type)' mismatch:" + context.debugDescription)
                Globals.logToScreen("JSON - codingPath:" + context.codingPath.debugDescription)
                
            } catch {
                Globals.logToScreen("JSON - error: " + error.localizedDescription)
            }
        }
        
        return nil
    }
}

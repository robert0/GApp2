//
//  FileSystem.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

public class FileSystem {

    /**
     * Write the local gestures data
     *
     * @param gestures
     */
    public static func writeLocalGesturesDataFile(_ gestures: [Gesture4D]) -> Void {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(Device.LocalGesturesDataFileName)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            //encoder.keyEncodingStrategy = .convertToSnakeCase
            //encoder.dateEncodingStrategy = .iso8601
            //encoder.dataEncodingStrategy = .base64
            try encoder
                .encode(gestures)
                .write(to: fileURL)
        } catch {
            Globals.log("Error saving localGesturesDataFile JSON: \(error)")
        }
    }
    
    /**
     *  Read the local file of gestures data
     *
     * @return gestures
     */
    public static func readLocalGesturesDataFile() -> [Gesture4D] {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(Device.LocalGesturesDataFileName)
            
            let data = try Data(contentsOf: fileURL)
            let pastData = try JSONDecoder().decode([Gesture4D].self, from: data)
            
            return pastData
        } catch {
            Globals.log("Error reading localGesturesDataFile JSON: \(error)")
            return []
        }
    }
            
    /**
     * Write the local gestures data
     *
     * @param gestures
     */
    public static func writeLocalGesturesMappingsDataFile(_ gestures: [InGesture]) -> Void {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(Device.LocalGesturesDataFileName)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            //encoder.keyEncodingStrategy = .convertToSnakeCase
            //encoder.dateEncodingStrategy = .iso8601
            //encoder.dataEncodingStrategy = .base64
            try encoder
                .encode(gestures)
                .write(to: fileURL)
        } catch {
            Globals.log("Error saving localGesturesDataFile JSON: \(error)")
        }
    }
}

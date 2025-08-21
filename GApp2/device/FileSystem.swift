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
    public static func writeLocalSshDataBeanFile(_ sshData: SshDataBean) -> Void {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(Device.LocalSSHDataFileName)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            //encoder.keyEncodingStrategy = .convertToSnakeCase
            //encoder.dateEncodingStrategy = .iso8601
            //encoder.dataEncodingStrategy = .base64
            try encoder
                .encode(sshData)
                .write(to: fileURL)
            ToastManager.show("Data saved successfully", ToastSeverity.success)
            
        } catch {
            Globals.log("Error saving localSSHDataFile JSON: \(error)")
        }
    }
    
    /**
     *  Read the local file of SSH data
     *
     *  @return sshData
     */
    public static func readSshDataBeanFile() -> SshDataBean? {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(Device.LocalSSHDataFileName)
            
            let data = try Data(contentsOf: fileURL)
            let sshData = try JSONDecoder().decode(SshDataBean.self, from: data)
            
            return sshData
        } catch {
            Globals.log("Error reading localSSHDataFile JSON: \(error)")
            return nil
        }
    }
    


    
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
            
            ToastManager.show("Data saved successfully", ToastSeverity.success)
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
     * Write the file of incomming gestures mapping data
     *
     * @param gestures
     */
    public static func writeIncommingGesturesMappingsDataFile(_ gestures: [InGestureMapping]) -> Void {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(Device.IncommingGesturesDataFileName)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            //encoder.keyEncodingStrategy = .convertToSnakeCase
            //encoder.dateEncodingStrategy = .iso8601
            //encoder.dataEncodingStrategy = .base64
            try encoder
                .encode(gestures)
                .write(to: fileURL)
            
            ToastManager.show("Data saved successfully", ToastSeverity.success)
        } catch {
            Globals.log("Error saving incommingGesturesDataFile JSON: \(error)")
        }
    }
    
    
    /**
     *  Read the file of incomming gestures mapping data
     *
     * @return gestures
     */
    public static func readIncommingGesturesMappingDataFile() -> [InGestureMapping] {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(Device.IncommingGesturesDataFileName)
            
            let data = try Data(contentsOf: fileURL)
            let pastData = try JSONDecoder().decode([InGestureMapping].self, from: data)
            
            return pastData
        } catch {
            Globals.log("Error reading incommingGesturesDataFile JSON: \(error)")
            return []
        }
    }
}

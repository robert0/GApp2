//
//  CommandExecutor.swift
//  GMacApp
//
//  Created by Robert Talianu
//

import Foundation


class CommandExecutor {
    
    //
    func executeCommand(_ command: String) {
        //Process.launchedProcess(launchPath: "/bin/sh", arguments: ["ls"])
        
        //        let task = Process()
        //        task.executableURL = URL(fileURLWithPath: "/bin/sh")
        //        task.arguments = ["ls"]
        //
        //        let pipe = Pipe()
        //        task.standardOutput = pipe
        //        do {
        //            try task.run()
        //            task.waitUntilExit()
        //
        //        } catch {
        //            Globals.logToScreen("Error: \(error)")
        //        }
    }
    
    //
    //    func shell(_ command: String) -> Int32 {
    //        let task = Process()
    //        task.launchPath = "/usr/bin/env"
    //        task.arguments = ["bash", "-c", command]
    //        task.launch()
    //        task.waitUntilExit()
    //        return task.terminationStatus
    //    }
}

//
//  AppleScriptCmd.swift
//  GApp
//
//  Created by Robert Talianu
//

import Foundation

public enum ScriptCmd: String, Command {
    
    /// Play the current song in iTunes
    case macOs_startKeynoteApp_Play = """
         osascript <<EndOfScript
            tell application "Keynote"
                activate
                if not playing then start the front document
            end tell
         EndOfScript
         """
    
    /// Show next slide in Keynote
    case macOs_pgDownKeyPress = "osascript -e 'tell application \"System Events\" to key code 121'"// pgDn key code
    
    /// Show previous slide in Keynote
    case macOs_pgUpKeyPress = "osascript -e 'tell application \"System Events\" to key code 116'" // pgUp key code
    
    /// Open Safari and navigate to Google
    case macOs_openGoogle = """
         osascript <<EndOfScript        
            if running of application \"Safari\" is true then
                    tell application \"Safari\"
                    activate
                    try
                         open location \"https://www.google.com\"
                    end try
                end tell
            end if
        EndOfScript
        """
    /// Open Safari and navigate to Facebook
    case macOs_openFacebook = """
         osascript <<EndOfScript 
            if running of application \"Safari\" is true then
                    tell application \"Safari\"
                    activate
                    try
                         open location \"https://www.facebook.com\"
                    end try
                end tell
            end if
         EndOfScript
         """
    
    case win_List_directory = "dir"
    
    case customCmd = "< Custom Command >"
    
    
    
    
    
    ///
    ///
    ///
    ///
    public var id: Self { self }
    
    
    ///
    /// Get the system type for the command.
    ///
    public func system() -> String {
        switch(self) {
        case .macOs_startKeynoteApp_Play:
            return "macOs"
            
        case .customCmd:
            return "macOs win"
            
        default:
            return "win"
        }
    }
    
    /// Convert to string to display in menus and pickers.
    func stringValue() -> String {
      switch(self) {
          
      // MacOs commands
      case .macOs_startKeynoteApp_Play:
        return "MacOs: Start Keynote App & Play"
      case .macOs_pgDownKeyPress:
        return "MacOs: Page Down Key Press (Next Slide)"
      case .macOs_pgUpKeyPress:
        return "MacOs: Page Up Key Press (Previous Slide)"
      case .macOs_openGoogle:
        return "MacOs: Open Google Page"
      case .macOs_openFacebook:
        return "MacOs: Open Facebook Page"
          
      // Windows commands
      case .win_List_directory:
        return "Windows: List Directory Files"
          
      //
      case .customCmd:
        return "< Custom Command >"
      }
    }
}

    
    
    
//    func example() {
//            var script = NSAppleScript (source: """
//            tell application "Music"
//                play
//                repeat with vlm from 0 to 100 by 1
//                    set the sound volume to vlm
//                    delay \(fadetime / 100)
//                end repeat
//            end tell
//            """)
//            DispatchQueue.global(qos: .background).async {
//                let success = script?.compileAndReturnError(nil)
//                assert(success != nil)
//                print(success)
//            }
//        }
    
    
//    func ex2 (){
//        let myAppleScript = "..."
//        var error: NSDictionary?
//        if let scriptObject = NSAppleScript(source: myAppleScript) {
//            if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
//                print(outputString)
//            } else if (error != nil) {
//                print("error: ", error!)
//            }
//        }
//    }


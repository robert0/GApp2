//
//  SSHCommands.swift
//  Ssh_cli2
//
//  Created by Robert Talianu
//
public enum SSHCommands: String, CaseIterable, Identifiable {

    ///multiline using EndOfScript tag
    case startKeynoteApp_Play_cmd = """
        osascript <<EndOfScript
            tell application "Keynote"
                activate
                if not playing then start the front document
            end tell
        EndOfScript
        """

    case keynoteNextSlide_cmd = "osascript -e 'tell application \"System Events\" to key code 121'"// pgDn key code
    
    case keynotePreviousSlide_cmd = "osascript -e 'tell application \"System Events\" to key code 116'" // pgUp key code
    
    case openYahoo = """
        if running of application \"Safari\" is true then
                tell application \"Safari\"
                activate
                try
                     open location \"https://www.google.com\"
                end try
            end tell
        end if
        """
    case openFacebook = """
        if running of application \"Safari\" is true then
                tell application \"Safari\"
                activate
                try
                     open location \"https://www.facebook.com\"
                end try
            end tell
        end if
        """
    
    public var id: Self { self }
}

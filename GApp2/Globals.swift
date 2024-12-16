//
//  Globals.swift
//  GApp
//
//  Created by Robert Talianu
//

import Combine
import Foundation
import os

class Globals {
    //singleton holding console, used by static funcs
     private static var sharedInstance = Globals()
     private var updateFun: ((String) -> Void)?
     private var consoleN: String = "" {
         //willSet() { }
         didSet {
             updateFun?(Globals.sharedInstance.consoleN)
         }
     }
    
    @Published var logger = Logger(
        //        subsystem: Bundle.main.bundleIdentifier!,
        //        category: String(describing: ProductsViewModel.self)
        )

    
    /**
     * Constructor
     */
    init() {
        logger.info("Application Started!...")
    }

   
    /**
     *
     */
    static func logToScreen(_ message: String) {
        Globals.sharedInstance.consoleN.append("\n#  \(message)")
        Globals.sharedInstance.consoleN = String(Globals.sharedInstance.consoleN.suffix(2000))
    }
    
    /**
     *
     */
    static func setChangeCallback(_ fn:((String) -> Void)?) {
        sharedInstance.updateFun = fn
        if(sharedInstance.consoleN.isEmpty){
            sharedInstance.consoleN = "UI Console Started..."
        }
    }
}

//
//  InGestureStore.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

public class InGestureStore {
    private var dataMap = Dictionary<String, InGesture>()
    
    /**
     * @param key
     * @return
     */
    public func getGesture(_ key:String) -> InGesture? {
        return dataMap[key]
    }
    
    /**
     * @param key
     * @return
     */
    public func setGesture(_ key:String, _ gs: InGesture? ){
        return dataMap[key] = gs
    }
    
    /**
     * removes gesture binding to the given key
     */
    public func removeGesture(_ key:String){
        dataMap[key] = nil
    }
    
    /**
     * Removes gesture and clears all its data
     */
    public func deleteGesture(_ key:String){
        dataMap[key] = nil
    }

    
    /**
     *
     */
    public func deleteAll(){
        for key in dataMap.keys {
            deleteGesture(key)
        }
    }
        
    /**
     *
     * @return
     */
    public func getAllGestures()-> [InGesture]{
        return Array(dataMap.values)
    }
    
    /**
     *
     * @return
     */
    public func getKeys() -> [String] {
        return Array(dataMap.keys)
    }
}

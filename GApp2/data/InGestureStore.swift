//
//  InGestureStore.swift
//  GApp2
//
//  Created by Robert Talianu
//

import Foundation

public class InGestureStore {
    private var dataMap = Dictionary<String, InGestureMapping>()
    
    /**
     * @param key
     * @return
     */
    public func getGestureMapping(_ key:String) -> InGestureMapping? {
        return dataMap[key]
    }
    
    /**
     * @param key
     * @return
     */
    public func setGestureMapping(_ key:String, _ gs: InGestureMapping? ){
        return dataMap[key] = gs
    }
    
    /**
     * removes gesture binding to the given key
     */
    public func removeGestureMapping(_ key:String){
        dataMap[key] = nil
    }
    
    /**
     * Removes gesture and clears all its data
     */
    public func deleteGestureMapping(_ key:String){
        dataMap[key] = nil
    }

    
    /**
     *
     */
    public func deleteAll(){
        for key in dataMap.keys {
            deleteGestureMapping(key)
        }
    }
        
    /**
     *
     * @return
     */
    public func getAllGestures()-> [InGestureMapping]{
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

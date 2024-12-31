//
//  Multi4DGestureData.swift
//  GApp2
//
//  Created by Robert Talianu
//


public class MultiGesture4DData {

    private var dataMap = Dictionary<String, Gesture4D>()
    private var baseMap = Dictionary<String, BaseSignalProp4D>()
    private var capacity: Int
    private var level = 1.0

    /**
     *
     * @param capacity
     * @param level
     * @param keys
     */
    init(_ capacity: Int,_ level: Double,_ keys: [String]) {
        self.capacity = capacity;
        self.level = level;
        for key in keys {
            dataMap[key] = Gesture4D()
            baseMap[key] = nil
        }
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    public func add(_ key:String,_ x: Double,_ y: Double,_ z: Double,_ time: Int64) {
        var gesture = dataMap[key]
        if(gesture == nil){
            gesture = Gesture4D()
            dataMap[key] = gesture
        }
        //Globals.log("add: " + String(gesture!.size()))
        if (gesture!.size() < self.capacity) {
            gesture!.add(x, y, z, time)
            baseMap[key] = nil
        }
    }
    
    /**
     * removes gesture binding to the given key
     */
    public func remove(_ key:String){
        dataMap[key] = nil
        baseMap[key] = nil
    }
    
    /**
     * Removes gesture and clears all its data
     */
    public func clear(_ key:String){
        dataMap[key]?.removeAll()
        dataMap[key] = nil
        baseMap[key] = nil
    }

    
    /**
     *
     */
    public func clearAll(){
        for key in dataMap.keys {
            clear(key)
        }
    }
    
    /**
     *
     * @return
     */
    public func getCapacity() -> Int {
        return capacity
    }
        
    /**
     * @param key
     * @return
     */
    public func getGesture(_ key:String) -> Gesture4D? {
        return dataMap[key]
    }
    
    /**
     * @param key
     * @return
     */
    public func setGesture(_ key:String, _ gs: Gesture4D? ){
        return dataMap[key] = gs
    }
    
    /**
     * @param key
     * @param data
     * @return
     */
    public func setData(_ key:String, _ data: [Sample4D]? ){
        var gs = dataMap[key]
        if(gs == nil){
            gs = Gesture4D()
            dataMap[key] = gs
        }
        
        gs!.setData(data!)
        baseMap[key] = nil
    }
    
    /**
     * @param key
     * @return
     */
    public func getData(_ key:String) -> [Sample4D]? {
        var gs = dataMap[key]
        if(gs != nil){
            return gs!.getData()
        }
        return []
    }

    /**
     * @param key
     * @return
     */
    public func getPointer(_ key:String) -> Int {
        if(dataMap[key] != nil){
            return dataMap[key]!.getData().count
        }
        return 0
    }
    
    /**
     *
     * @return
     */
    public func getKeys() -> [String] {
        return Array(dataMap.keys)
    }
    
    /**
     *
     * @param key
     * @return
     */
    public func getBase(_ key:String) -> BaseSignalProp4D? {
        let signal = dataMap[key]?.getData()
        if (signal == nil || signal!.isEmpty) {
            return nil
        }
        
        var  base = baseMap[key]
        if (base == nil) {
            base = ArrayMath4D.extractBaseAboveLevel(dataMap[key]!.getData(), self.level, false);
            base?.setKey(key);
            baseMap[key] = base;
        }
        
        return base
    }
}

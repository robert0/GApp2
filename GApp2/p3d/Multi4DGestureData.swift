//
//  Multi4DGestureData.swift
//  GApp
//
//  Created by Robert Talianu
//


public class Multi4DGestureData {

    private var dataMap = Dictionary<String, [Sample4D]>()
    private var baseMap = Dictionary<String, BaseSignalProp4D>()
    private var capacity: Int
    private var level = 1.0

    /**
     *
     * @param capacity
     */
    init(_ capacity: Int,_ level: Double,_ keys: [String]) {
        self.capacity = capacity;
        self.level = level;
        for key in keys {
            dataMap[key] = []
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
        var data = dataMap[key]! // this should not be null
        if (data.count < self.capacity) {
            data.append(Sample4D(x, y, z, time))
            dataMap[key] = data
            baseMap[key] = nil
        }
    }
    
    /**
     *
     */
    public func clear(_ key:String){
            dataMap[key]?.removeAll()
        baseMap[key] = nil
    }

    
    /**
     *
     */
    public func clearAll(){
        for key in dataMap.keys {
            dataMap[key]?.removeAll()
            baseMap[key] = nil
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
     *
     * @return
     */
    public func getData(_ key:String) -> [Sample4D] {
            return dataMap[key]!
    }

    /**
     *
     * @return
     */
    public func getPointer(_ key:String) -> Int {
        return dataMap[key]!.count
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
    public func  getBase(_ key:String) -> BaseSignalProp4D? {
        let signal = dataMap[key]
        if (signal == nil || signal!.isEmpty) {
            return nil
        }
        
        var  base = baseMap[key]
        if (base == nil) {
            base = ArrayMath4D.extractBaseAboveLevel(dataMap[key]!, self.level, false);
            base?.setKey(key);
            baseMap[key] = base;
        }
        
        return base
    }
}

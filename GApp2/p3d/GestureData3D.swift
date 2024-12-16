//
//  GestureData3D.swift
//  GApp
//
//  Created by Robert Talianu
//

public class GestureData3D {
    private var data: [Sample3D] = []
    private var capacity: Int

    /**
     *
     * @param capacity
     */
    init(_ capacity: Int) {
        self.capacity = capacity
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    public func add(_ x: Double, _ y: Double, _ z: Double) {
        if data.count < self.capacity {
            data.append(Sample3D(x, y, z))
        }
    }

    /**
     *
     */
    public func clear() {
        data.removeAll()
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
    public func getData() -> [Sample3D] {
        return data
    }

    /**
     *
     * @return
     */
    public func getPointer() -> Int {
        return data.count
    }
}

//
//  RollingQueue.swift
//  GApp
//
//  Created by Robert Talianu
//

/// @param <T>
public class RollingQueue<T>: LinkedList<T> {
    private let capacity: Int

    init(_ capacity: Int) {
        self.capacity = capacity
    }

    public override func add(_ e: T) {
        if size() >= capacity {
            removeFirst()
        }
        return super.add(e)
    }
}

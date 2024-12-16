//
//  CircularIterator.swift
//  GApp
//
//  Created by Robert Talianu
//

/**
 *
 */
public class CircularIterator<T> {
    private var list: [T] = []
    private var maxCount: Int = 100
    private var cindex: Int = 0

    /**
     * constructor
     */
    init(_ list:[T], _ count: Int) {
        self.list = list
        self.maxCount = count
    }
    
    /**
     * constructor
     */
    init(count: Int) {
        self.maxCount = count
    }

    /**
     * @return
     */
    public func hasNext() -> Bool {
        return cindex < maxCount
    }

    /**
     * @return
     */
    public func next() -> T {
        self.cindex += 1
        if cindex >= maxCount {
            cindex = 0
        }
        return list[cindex % list.count]
    }

    /**
     * @return
     */
    public func current() -> T {
        return list[cindex % list.count]
    }

    /**
     * @return
     */
    public func set(item: T) {
        list[cindex % list.count] = item
    }

    /**
     * @return
     */
    public func add(item: T) {
        list[cindex % list.count] = item
        cindex += 1
    }
}

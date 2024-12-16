//
//  CircularIterator.swift
//  GApp
//
//

public class LinkedList<T> {
    private var head: Node<T>?
    private var tail: Node<T>?
    private var count: Int = 0

    /**
     * @return
     */
    public var isEmpty: Bool {
        return head == nil
    }

    /**
     * @return
     */
    public func getFirst() -> T? {
        return head?.value
    }

    /**
     * @return
     */
    public func getLast() -> T? {
        return tail?.value
    }

    /**
     * @return
     */
    public func add(_ value: T) {
        let newNode = Node(value: value)
        if isEmpty {
            head = newNode
            tail = newNode
        } else {
            tail?.next = newNode
            newNode.previous = tail
            tail = newNode
        }
        count += 1
    }
        
    /**
     * @return
     */
    public func removeLast() -> T {
        return _remove(node: tail!)
    }

    /**
     * @return
     */
    public func removeFirst() -> T {
        return _remove(node: head!)
    }
    

    /**
     * @return
     */
    public func size()-> Int {
        return count
    }

    /**
     * @return
     */
    public func node(atIndex index: Int) -> Node<T> {
        if index == 0 {
            return head!
        } else {
            var node = head!.next
            for _ in 1..<index {
                node = node?.next
                if node == nil {  //(*1)
                    break
                }
            }
            return node!
        }
    }

    /**
     * @return
     */
    public func insert(value: T, atIndex index: Int) {
        let newNode = Node(value: value)
        if index == 0 {
            newNode.next = head
            head?.previous = newNode
            head = newNode
        } else {
            let previousNode = self.node(atIndex: index - 1)
            let nextNode = previousNode.next

            newNode.previous = previousNode
            newNode.next = previousNode.next
            previousNode.next = newNode
            nextNode?.previous = newNode
        }
        count += 1
    }

    /**
     * @return
     */
    private func _remove(node: Node<T>) -> T {
        let previousNode = node.previous
        let nextNode = node.next

        if let previousNode = previousNode {
            previousNode.next = nextNode
        } else {
            head = nextNode
        }
        nextNode?.previous = previousNode

        node.previous = nil
        node.next = nil
        count -= 1
        return node.value
    }

    /**
     * @return
     */
    public func removeAt(_ index: Int) -> T {
        let nodeToRemove = node(atIndex: index)
        return _remove(node: nodeToRemove)
    }

    /**
     * @return
     */
    public var print: String {
        var s = "["
        var node = head
        while node != nil {
            s += "\(node!.value)"
            node = node!.next
            if node != nil { s += ", " }
        }
        return s + "]"
    }
    
    /**
     * @return
     */
    public func asList() -> [T] {
        var list: [T] = []
        var node = head
        while node != nil {
            list.append(node!.value)
            node = node!.next
        }
        return list
    }
}

//
//  PurelyFunctionalDataStructures.swift
//  PurelyFunctionalDataStructures
//
//  Created by CHM on 2020/1/7.
//  Copyright © 2020 CHM. All rights reserved.
//

import Foundation

// empty 返回一个空的无序集合
// isEmpty 检查一个无序集合是否为空
// contains 检查无序集合中是否包含某个元素
// insert 向无序集合中插入一个元素

// 用数组实现
func empty<Element>() -> [Element] {
    return []
}

func isEmpty<Element>(set: [Element]) -> Bool {
    return set.isEmpty
}

func contains<Element: Equatable>(x: Element, _ set: [Element]) -> Bool {
    return set.contains(x)
}

func insert<Element: Equatable>(x: Element, _ set: [Element]) -> [Element] {
    return contains(x: x, set) ? set : set + [x]
}

indirect enum BinarySearchTree<Element: Comparable> {
    case Leaf
    case Node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)
}

let leaf: BinarySearchTree<Int> = .Leaf
let five: BinarySearchTree<Int> = .Node(leaf, 5, leaf)

extension BinarySearchTree {
    init() {
        self = .Leaf
    }
    
    init(_ value: Element) {
        self = .Node(.Leaf, value, .Leaf)
    }
}

extension BinarySearchTree {
    var count: Int {
        switch self {
        case .Leaf:
            return 0
        case let .Node(left, _, right):
            return 1 + left.count + right.count
        }
    }
}

extension BinarySearchTree {
    var elements: [Element] {
        switch self {
        case .Leaf:
            return []
        case let .Node(left, x, right):
            return left.elements + [x] + right.elements
        }
    }
}

extension BinarySearchTree {
    var isEmpty: Bool {
        if case .Leaf = self {
            return true
        }
        return false
    }
}

//extension BinarySearchTree where Element: Comparable {
//    var isBST: Bool {
//        switch self {
//        case .Leaf:
//            return true
//        case let .Node(left, x, right):
//            return left.elements.all {y in y < x }
//                && right.elements.all { y in y > x }
//                && left.isBST
//                && right.isBST
//        }
//    }
//}

//extension Sequence {
//    func all(predicate: (Generator.Element) -> Bool) -> Bool {
//        for x in self where !predicate(x) {
//            return false
//        }
//        return true
//    }
//}

extension BinarySearchTree {
    func contains(x: Element) -> Bool {
        switch self {
        case .Leaf:
            return false
        case let .Node(_, y, _) where x == y:
            return true
        case let .Node(left, y, _) where x < y:
            return left.contains(x: x)
        case let .Node(_, y, right) where x > y:
            return right.contains(x: x)
        default:
            fatalError("The impossible occurred")
        }
    }
}

extension BinarySearchTree {
    mutating func insert(x: Element) {
        switch self {
        case .Leaf:
            self = BinarySearchTree(x)
        case .Node(var left, let y, var right):
            if x < y { left.insert(x: x) }
            if x > y { right.insert(x: x) }
            self = .Node(left, y, right)
        }
    }
}

//let myTree: BinarySearchTree<Int> = BinarySearchTree()
//var copid = myTree
//copid.insert(x: 5)
//(myTree.elements, copid.elements) // ([], [5])

func autocomplete(history: [String], textEntered: String) -> [String] {
    return history.filter { $0.hasPrefix(textEntered) }
}

struct Trie<Element: Hashable> {
    let isElement: Bool
    let children: [Element: Trie<Element>]
}

extension Trie {
    init() {
        isElement = false
        children = [:]
    }
}

//extension Trie {
//    var elements: [[Element]] {
//        var result: [[Element]] = isElement ? [[]]: []
//        for (key, value) in children {
//            result += value.elements.map { [key] + $0 }
//        }
//        return result
//    }
//}

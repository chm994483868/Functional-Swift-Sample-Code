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
    return contains(x: x, set) ? set : [x] + set
}

// 支持递归的枚举
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
    
    var elements: [Element] {
        switch self {
        case .Leaf:
            return []
        case let .Node(left, x, right):
            return left.elements + [x] + right.elements
        }
    }
    
    var isEmpty: Bool {
        if case .Leaf = self {
            return true
        }
        return false
    }
}

extension BinarySearchTree where Element: Comparable {
    var isBST: Bool {
        switch self {
        case .Leaf:
            return true
        case let .Node(left, x, right):
            return left.elements.all { $0 < x }
                && right.elements.all { $0 > x }
                && left.isBST
                && right.isBST
        }
    }
}

extension Sequence {
    func all(predicate: (Iterator.Element) -> Bool) -> Bool {
        for x in self where !predicate(x) {
            return false
        }
        return true
    }
    
}

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
//var copied = myTree
//copied.insert(x: 5)
//(myTree.elements, copied.elements)

func autocomplete(history: [String], textEntered: String) -> [String] {
    return history.filter { $0.hasPrefix(textEntered) }
}

struct Trie<Element: Hashable> {
    let isElement: Bool
    let children: [Element: Trie<Element>]
    
    init() {
        isElement = false
        children = [:]
    }
    
    init(isElement: Bool, children: [Element: Trie<Element>]) {
        self.isElement = isElement
        self.children = children
    }
    
    var elements: [[Element]] {
        var result: [[Element]] = isElement ? [[]] : []
        for (key, value) in children {
            result += value.elements.map { [key] + $0 }
        }
        return result
    }
}

extension Array {
    var decompose: (Element, [Element])? {
        return isEmpty ? nil : (self[startIndex], Array(self.dropFirst()))
    }
}

// 递归求和
func sum(xs: [Int]) -> Int {
    guard let (head, tail) = xs.decompose else {
        return 0
    }
    return head + sum(xs: tail)
}

/// 快速排序
/// - Parameter input:
func qsort(input: [Int]) -> [Int] {
    guard let (pivot, rest) = input.decompose else {
        return []
    }
    
    let lesser = rest.filter { $0 < pivot } // 统计小于第一个元素的所有元素
    let greater = rest.filter { $0 >= pivot } // 统计大于等于第一个元素的所有元素
    
    return qsort(input: lesser) + [pivot] + qsort(input: greater) // 拼接
}

extension Trie {
    func lookup(key: [Element]) -> Bool {
        guard let (head, tail) = key.decompose else { return isElement } // 如果 key 是空数组，返回 Trie 实例的 isElement
        guard let subtrie = children[head] else { return false }
        return subtrie.lookup(key: tail)
    }
    
    func withPrefix(prefix: [Element]) -> Trie<Element>? {
        guard let (head, tail) = prefix.decompose else { return self } // 如果 key 是空数组，返回 Trie 实例
        guard let remainder = children[head] else { return nil }
        return remainder.withPrefix(prefix: tail)
    }
    
    func autocomplete(key: [Element]) -> [[Element]] {
        return withPrefix(prefix: key)?.elements ?? []
    }
    
    init(_ key: [Element]) {
        if let (head, tail) = key.decompose {
            let children = [head: Trie(tail)]
            self = Trie(isElement: false, children: children)
        } else {
            self = Trie(isElement: true, children: [:])
        }
    }
    
    func insert(key: [Element]) -> Trie<Element> {
        guard let (head, tail) = key.decompose else { return Trie(isElement: true, children: children) }
        var newChildren = children
        if let nextTrie = children[head] {
            newChildren[head] = nextTrie.insert(key: tail)
        } else {
            newChildren = Trie(tail)
        }
        return Trie(isElement: isElement, children: newChildren)
    }
}

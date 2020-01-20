//
//  Chart.swift
//  Chart
//
//  Created by HM C on 2020/1/16.
//  Copyright © 2020 HM C. All rights reserved.
//

import Foundation
import UIKit

//extension Sequence where Element == CGFloat {
//    func normalize() -> [CGFloat] {
//        var maxVal: CGFloat = 0.0
//        self.forEach { element in
//            if element > maxVal {
//                maxVal = element
//            }
//        }
//
//        return self.map { $0 / maxVal }
//    }
//}

//func barGraph(input: [(String, Double)]) -> Diagram {
//    let values: [CGFloat] = input.map { CGFloat($0.1) } // 把 input 的 double 都转换为 CGFloat
//    let nValues = values.normalize()
//    let bars = hcat(nValues.map({ (x: CGFloat) -> Diagram in
//        return rect(width: 1, height: 3 * x).fill(.blackColor()).alignBottom()
//    }))
//    let labels = hcat(input.map({ x in
//        return text(x.0, width: 1, height: 0.3).alignTop()
//    }))
//    return bars --- labels
//}

//let cities: Array<(String, Double)> = [
//    ("Shanghai", 14.01),
//    ("Istanbul", 13.3),
//    ("Moscow", 10.56),
//    ("New York", 8.33),
//    ("Berlin", 3.43)
//]

//let example3 = barGraph(cities)

enum Primitive {
    case Ellipse
    case Rectangle
    case Text(String)
}

indirect enum Diagram {
    case Prim(CGSize, Primitive)
    case Beside(Diagram, Diagram)
    case Below(Diagram, Diagram)
    case Attributed(Attribute, Diagram)
    case Align(CGVector, Diagram)
}

enum Attribute {
    case FillColor(CGColor)
}

extension Diagram {
    var size: CGSize {
        switch self {
        case .Prim(let size, _):
            return size
        case .Attributed(_, let x):
            return x.size
        case .Beside(let l, let r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSize(width: sizeL.width + sizeR.width, height: max(sizeL.height, sizeR.height))
        case .Below(let l, let r):
            return CGSize(width: max(l.size.width, r.size.width), height: l.size.height + r.size.height)
        case .Align(_, let r):
            return r.size
        }
    }
}

extension CGSize {
    func fit(vector: CGVector, _ rect: CGRect) -> CGRect {
        let scaleSize = rect.size / self
        let scale = min(scaleSize.width, scaleSize.height)
        let size = scale * self
        let space = vector.size * (size - rect.size)
        return CGRect(origin: rect.origin - space.point, size: size)
    }
}

func *(l: CGFloat, r: CGSize) -> CGSize {
    return CGSize(width: l * r.width, height: l * r.height)
}

func /(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width / r.width, height: l.height / r.height)
}

func *(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width * r.width, height: l.height * r.height)
}

func -(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width - r.width, height: l.height - r.height)
}

func -(l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x - r.x, y: l.y - r.y)
}

extension CGSize {
    var point: CGPoint {
        return CGPoint(x: self.width, y: self.height)
    }
}

extension CGVector {
    var point: CGPoint { return CGPoint(x: dx, y: dy) }
    var size: CGSize { return CGSize(width: dx, height: dy) }
}

//CGSize(width: 1, height: 1).fit(vector: CGVector(dx: 0.5, dy: 0.5), CGRect(x: 0, y: 0, width: 200, height: 100))
//CGSize(width: 1, height: 1).fit(vector: CGVector(dx: 0, dy: 0.5), CGRect(x: 0, y: 0, width: 200, height: 100))

extension CGContext {
    func draw(bounds: CGRect, _ diagram: Diagram) {
        switch diagram {
        case .Prim(let size, .Ellipse):
            let frame = size.fit(vector: CGVector(dx: 0.5, dy: 0.5), bounds)
            CGContext.fillEllipse(self)(in: frame)
        case .Prim(let size, .Rectangle):
            let frame = size.fit(vector: CGVector(dx: 0.5, dy: 0.5), bounds)
            CGContext.fill(self)(frame)
        case .Prim(let size, .Text(let text)):
            let frame = size.fit(vector: CGVector(dx: 0.5, dy: 0.5), bounds)
            let font = UIFont.systemFont(ofSize: 12)
            let attributes = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.draw(in: frame)
        case .Attributed(.FillColor(let color), let d):
            CGContext.saveGState(self)()
            CGContext.setFillColor(self)(color)
            draw(bounds: bounds, d)
            CGContext.restoreGState(self)()
        case .Beside(let left, let right):
            let (lFrame, rFrame) = bounds.split(ratio: left.size.width / diagram.size.width, edge: .minXEdge)
            draw(bounds: lFrame, left)
            draw(bounds: rFrame, right)
        case .Below(let top, let bottom):
            let (lFrame, rFrame) = bounds.split(ratio: bottom.size.height / diagram.size.height, edge: .minYEdge)
            draw(bounds: lFrame, bottom)
            draw(bounds: rFrame, top)
        case .Align(let vec, let diagram):
            let frame = diagram.size.fit(vector: vec, bounds)
            draw(bounds: frame, diagram)
        }
    }
}

extension CGRect {
    func split(ratio: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let length = edge.isHorizontal ? width : height
        return divided(atDistance: length * ratio, from: edge)
    }
}

extension CGRectEdge {
    var isHorizontal: Bool {
        return self == .maxXEdge || self == .minXEdge
    }
}


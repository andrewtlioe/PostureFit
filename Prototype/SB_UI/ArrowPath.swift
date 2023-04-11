//
//  ArrowPath.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 4/8/23.
//

import UIKit

extension UIBezierPath {

    class func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength

        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        var points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]

        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        var transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)

      let path = CGMutablePath()
      path.addLines(between: points, transform: transform)
      path.closeSubpath()

      return self.init(cgPath: path)
    }

}

// Example call:
/*let arrow = UIBezierPath.arrow(from: CGPointMake(50, 100), to: CGPointMake(200, 50),
    tailWidth: 10, headWidth: 25, headLength: 40)*/

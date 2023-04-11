//
//  CorrectorView.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 3/19/23.
//

import UIKit
import SwiftUI
import os

/// Custom view to visualize the pose estimation result on top of the input image.
/// Receive body part which needs correction
class OverlayView: UIImageView {

  /// Visualization configs
  private enum Config {
    static let dot = (radius: CGFloat(10), color: UIColor.orange)
    //static let line = (width: CGFloat(5.0), color: UIColor.orange)
  }

  /// List of lines connecting each part to be visualized.
  private static let lines = [
    (from: BodyPart.leftWrist, to: BodyPart.leftElbow),
    (from: BodyPart.leftElbow, to: BodyPart.leftShoulder),
    (from: BodyPart.leftShoulder, to: BodyPart.rightShoulder),
    (from: BodyPart.rightShoulder, to: BodyPart.rightElbow),
    (from: BodyPart.rightElbow, to: BodyPart.rightWrist),
    (from: BodyPart.leftShoulder, to: BodyPart.leftHip),
    (from: BodyPart.leftHip, to: BodyPart.rightHip),
    (from: BodyPart.rightHip, to: BodyPart.rightShoulder),
    (from: BodyPart.leftHip, to: BodyPart.leftKnee),
    (from: BodyPart.leftKnee, to: BodyPart.leftAnkle),
    (from: BodyPart.rightHip, to: BodyPart.rightKnee),
    (from: BodyPart.rightKnee, to: BodyPart.rightAnkle),
  ]

  /// CGContext to draw the detection result.
  var context: CGContext!

  /// Draw the detected keypoints on top of the input image.
  ///
  /// - Parameters:
  ///     - image: The input image.
  ///     - person: Keypoints of the person detected (i.e. output of a pose estimation model)
  ///     - needCorrectionParts: List of parts needing arrow placement for correction recommendation
  func draw(at image: UIImage, person: Person, needCorrectionParts: [needCorrectionPart]) {
    if context == nil {
      UIGraphicsBeginImageContext(image.size)
      guard let context = UIGraphicsGetCurrentContext() else {
        fatalError("set current context faild")
      }
      self.context = context
    }
    guard let strokes = strokes(from: person, needCorrectionParts: needCorrectionParts) else { return }
    image.draw(at: .zero)
    context.setLineWidth(Config.dot.radius)
    
    drawArrows(at: context, dots: strokes.dots, correctionParts: needCorrectionParts)
    
    context.setStrokeColor(UIColor.orange.cgColor) // color setting for drawings
    context.strokePath()
    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { fatalError() }
    self.image = newImage
  }
  
  /*let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height*/
  
  private func drawArrows(at context: CGContext, dots: [CGPoint], correctionParts: [needCorrectionPart]) { // get body part which needs correction and direction; maintain arrow configs for each direction of correction
    let dot = dots[0] // points to nose
    //print(dots)
    
    let upRight = (from: CGPointMake(dot.x - 30, dot.y + 30), to: CGPointMake(dot.x + 30, dot.y - 30))
    
    
    for (dot, correctionPart) in zip(dots, correctionParts) {
      print("In loop")
      
      let arrow = UIBezierPath.arrow(from: CGPointMake(dot.x + correctionPart.direction.from.x_adj, dot.y + correctionPart.direction.from.y_adj), to: CGPointMake(dot.x + correctionPart.direction.to.x_adj, dot.y + correctionPart.direction.to.y_adj),
                                       tailWidth: 5, headWidth: 10, headLength: 10) //in ArrowPath.swift; bottom-left to top-right
      
      //need coordinates in real-time from here
      
      /*
      let arrow = UIBezierPath.arrow(from: CGPointMake(correctionPart.coordinate.x + correctionPart.direction.from.x_adj, correctionPart.coordinate.y + correctionPart.direction.from.y_adj), to: CGPointMake(correctionPart.coordinate.x + correctionPart.direction.to.x_adj, correctionPart.coordinate.y + correctionPart.direction.to.y_adj),
                                       tailWidth: 5, headWidth: 10, headLength: 10) //in ArrowPath.swift; bottom-left to top-right */
      
      //let arrow = UIBezierPath.arrow(from: upRight.from, to: upRight.to,
                                       //tailWidth: 5, headWidth: 10, headLength: 10) //in ArrowPath.swift; bottom-left to top-right
      
      context.addPath(arrow.cgPath)
      
    }
  }


  /// Generate a list of strokes to draw in order to visualize the pose estimation result.
  ///
  /// - Parameters:
  ///     - person: The detected person (i.e. output of a pose estimation model).
  private func strokes(from person: Person, needCorrectionParts: [needCorrectionPart]) -> Strokes? {
    var strokes = Strokes(dots: [])
    // MARK: Visualization of detection result
    var bodyPartToDotMap: [BodyPart: CGPoint] = [:]
    /*for (index, part) in BodyPart.allCases.enumerated() {
      let position = CGPoint(
        x: person.keyPoints[index].coordinate.x,
        y: person.keyPoints[index].coordinate.y)
      bodyPartToDotMap[part] = position
      strokes.dots.append(position)*/
    
    for correctionPart in needCorrectionParts {
      for (index, part) in BodyPart.allCases.enumerated() {
        if (correctionPart.bodyPart == part) {
          let position = CGPoint(
            x: person.keyPoints[index].coordinate.x,
            y: person.keyPoints[index].coordinate.y)
          bodyPartToDotMap[part] = position
          strokes.dots.append(position)
        }
      }
    }

  
    return strokes
  }
}

/// The strokes to be drawn in order to visualize a pose estimation result.
fileprivate struct Strokes {
  var dots: [CGPoint]
}

fileprivate enum VisualizationError: Error {
  case missingBodyPart(of: BodyPart)
}

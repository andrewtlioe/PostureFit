//
//  SquatCorrector.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 4/11/23.
//

import UIKit


final class SquatCorrector: CorrectionEstimator {
  
  var wasInBottomPosition = false
  @Published var squatCount = 0
  @Published var isGoodPosture = true

// Runs RepetitionEstimation model with given image with given source area to destination area.
/// This repetition detector can process only one frame at each moment.
///
/// - Parameters:
///   - on: Input image to run the model.
/// - Returns: Result of the count incrementally
  func estimateCorrection(on result: Person) throws -> ([needCorrectionPart]) {
    //print("result: ", result)
    
    var rightKnee = KeyPoint.init(bodyPart: .rightKnee).coordinate
    var leftKnee = KeyPoint.init(bodyPart: .leftKnee).coordinate
    var rightHip = KeyPoint.init(bodyPart: .rightHip).coordinate
    var rightAnkle = KeyPoint.init(bodyPart: .rightAnkle).coordinate
    var leftAnkle = KeyPoint.init(bodyPart: .leftAnkle).coordinate
    
    var nose = KeyPoint.init(bodyPart: .nose).coordinate
    
    var needCorrectionParts = needCorrectionPart()
    
    for (index, part) in BodyPart.allCases.enumerated() {
      /*
       let position = CGPoint(
       x: result.keyPoints[index].coordinate.x,
       y: result.keyPoints[index].coordinate.y)
       */
      //print(index, part)
      
      switch (part) {
      case .rightKnee:
        rightKnee = result.keyPoints[index].coordinate
        //print(rightKnee.y)
        continue
      case .leftKnee:
        leftKnee = result.keyPoints[index].coordinate
        //print(leftKnee.y)
        continue
      case .rightHip:
        rightHip = result.keyPoints[index].coordinate
        //print(rightHip.y)
        continue
      case .rightAnkle:
        rightAnkle = result.keyPoints[index].coordinate
        //print(rightAnkle.y)
        continue
      case .leftAnkle:
        leftAnkle = result.keyPoints[index].coordinate
        //print(leftAnkle.y)
        continue
      case .nose:
        nose = result.keyPoints[index].coordinate
        //print(nose.y)
        continue
      case .leftEye:
        continue
      case .rightEye:
        continue
      case .leftEar:
        continue
      case .rightEar:
        continue
      case .leftShoulder:
        continue
      case .rightShoulder:
        continue
      case .leftElbow:
        continue
      case .rightElbow:
        continue
      case .leftWrist:
        continue
      case .rightWrist:
        continue
      case .leftHip:
        continue
      }
    }
    
    if nose.x <= leftKnee.x {
      
      needCorrectionParts.bodyPart = .nose
      needCorrectionParts.direction = Direction.upRight //need to be right after fix of arrows
      
      return ([needCorrectionParts])
    } else {
      needCorrectionParts.bodyPart = .nose
      needCorrectionParts.direction = Direction.upLeft //need to be right after fix of arrows
      
      return ([needCorrectionParts])
    }
    
  print("RepModel: return 0 end")
  return ([])
  }
  
  
}


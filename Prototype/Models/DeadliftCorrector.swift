//
//  DeadliftCorrector.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 4/16/23.
//

import UIKit


final class DeadliftCorrector: CorrectionEstimator {
  
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
    
    var needCorrectionParts = [needCorrectionPart]()
    
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
    
    ///All correction only consider left side of body
    
    ///For pts. 1, 2 and 3; referring to the squat journal by Myer et al. (2014). Lacking a toe keypoint in MoveNet
    var noseCorrection: needCorrectionPart = needCorrectionPart()
    
    if (nose.y - leftKnee.y) <= 20 {
      noseCorrection.bodyPart = .nose
      noseCorrection.direction = Direction.up //need to be right after fix of arrows
      
      needCorrectionParts.append(noseCorrection)
      
    }
    
    
    
    print("needCorrectionParts: ", needCorrectionParts)
    return (needCorrectionParts)
    
    
    
    
  print("RepModel: return 0 end")
  return ([])
  }
  
  
}



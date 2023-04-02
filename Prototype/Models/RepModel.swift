//
//  CountEstimator.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 3/19/23.
//

import UIKit


final class RepModel: RepetitionEstimator {
  
  var wasInBottomPosition = false
  @Published var squatCount = 0
  @Published var isGoodPosture = true

// Runs RepetitionEstimation model with given image with given source area to destination area.
/// This repetition detector can process only one frame at each moment.
///
/// - Parameters:
///   - on: Input image to run the model.
/// - Returns: Result of the count incrementally
  func estimateRepetition(on result: Person) throws -> (String) {
    //print("result: ", result)
    
    var rightKnee = KeyPoint.init(bodyPart: .rightKnee).coordinate
    var leftKnee = KeyPoint.init(bodyPart: .leftKnee).coordinate
    var rightHip = KeyPoint.init(bodyPart: .rightHip).coordinate
    var rightAnkle = KeyPoint.init(bodyPart: .rightAnkle).coordinate
    var leftAnkle = KeyPoint.init(bodyPart: .leftAnkle).coordinate
    
    var nose = KeyPoint.init(bodyPart: .nose).coordinate
    
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
    
    let hipHeight = rightHip.y
    let kneeHeight = rightKnee.y
    if hipHeight <= kneeHeight {
      //self.wasInBottomPosition = true
      /*print("RepModel: return 1; top")
      print("hipHeight: ", hipHeight)
      print("kneeHeight: ", kneeHeight)
      print("noseHeight: ", nose.y)*/
      return ("1 top")
    } else {
      /*print("RepModel: return 0 ; bottom")
      print("hipHeight: ", hipHeight)
      print("kneeHeight: ", kneeHeight)
      print("noseHeight: ", nose.y)*/
      return ("0 down")
    }
    
  print("RepModel: return 0 end")
  return ("NULL")
  }
  
  
}

//
//  DeadliftModel_Controller.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 4/5/23.
//

import UIKit


final class DeadliftModel_Controller: RepetitionEstimator {
  
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
    
    print("In estimateRepetition deadlift")
    
    var rightKnee = KeyPoint.init(bodyPart: .rightKnee)
    var leftKnee = KeyPoint.init(bodyPart: .leftKnee)
    var rightHip = KeyPoint.init(bodyPart: .rightHip)
    var leftHip = KeyPoint.init(bodyPart: .leftHip)
    var rightAnkle = KeyPoint.init(bodyPart: .rightAnkle)
    var leftAnkle = KeyPoint.init(bodyPart: .leftAnkle)
    var nose = KeyPoint.init(bodyPart: .nose)
    var leftEye = KeyPoint.init(bodyPart: .leftEye)
    var rightEye = KeyPoint.init(bodyPart: .rightEye)
    var leftEar = KeyPoint.init(bodyPart: .leftEar)
    var rightEar = KeyPoint.init(bodyPart: .rightEar)
    var leftShoulder = KeyPoint.init(bodyPart: .leftShoulder)
    var rightShoulder = KeyPoint.init(bodyPart: .rightShoulder)
    var leftElbow = KeyPoint.init(bodyPart: .leftElbow)
    var rightElbow = KeyPoint.init(bodyPart: .rightElbow)
    var leftWrist = KeyPoint.init(bodyPart: .leftWrist)
    var rightWrist = KeyPoint.init(bodyPart: .rightWrist)
    
    
    
    
    for (index, part) in BodyPart.allCases.enumerated() {
      switch (part) {
      case .rightKnee:
        rightKnee = result.keyPoints[index]
        //print(rightKnee.y)
        continue
      case .leftKnee:
        leftKnee = result.keyPoints[index]
        //print(leftKnee.y)
        continue
      case .rightHip:
        rightHip = result.keyPoints[index]
        //print(rightHip.y)
        continue
      case .leftHip:
        leftHip = result.keyPoints[index]
        continue
      case .rightAnkle:
        rightAnkle = result.keyPoints[index]
        //print(rightAnkle.y)
        continue
      case .leftAnkle:
        leftAnkle = result.keyPoints[index]
        //print(leftAnkle.y)
        continue
      case .nose:
        nose = result.keyPoints[index]
        //print(nose.y)
        continue
      case .leftEye:
        leftEye = result.keyPoints[index]
        continue
      case .rightEye:
        rightEye = result.keyPoints[index]
        continue
      case .leftEar:
        leftEar = result.keyPoints[index]
        continue
      case .rightEar:
        rightEar = result.keyPoints[index]
        continue
      case .leftShoulder:
        leftShoulder = result.keyPoints[index]
        continue
      case .rightShoulder:
        rightShoulder = result.keyPoints[index]
        continue
      case .leftElbow:
        leftElbow = result.keyPoints[index]
        continue
      case .rightElbow:
        rightElbow = result.keyPoints[index]
        continue
      case .leftWrist:
        leftWrist = result.keyPoints[index]
        continue
      case .rightWrist:
        rightWrist = result.keyPoints[index]
        continue
      }
    }
    
    
    /// Declare model to detect up/down for squat
    let upDownModel = DeadliftPosition() // change to deadlift model
    
    guard let upDownOutput = try? upDownModel.prediction(
      a1: Double(leftShoulder.coordinate.y - leftHip.coordinate.y)/Double(leftShoulder.coordinate.x-leftHip.coordinate.x),
      a2: Double(rightShoulder.coordinate.y - rightHip.coordinate.y)/Double(rightShoulder.coordinate.x-rightHip.coordinate.x),
      a3: Double(leftHip.coordinate.y - leftKnee.coordinate.y)/Double(leftHip.coordinate.x-leftKnee.coordinate.x),
      a4: Double(rightHip.coordinate.y - rightKnee.coordinate.y)/Double(rightHip.coordinate.x-rightKnee.coordinate.x),
      a5: Double(leftKnee.coordinate.y - leftAnkle.coordinate.y)/Double(leftKnee.coordinate.x-leftAnkle.coordinate.x),
      a6: Double(rightKnee.coordinate.y - rightAnkle.coordinate.y)/Double(rightKnee.coordinate.x - rightAnkle.coordinate.x))
    else {
        fatalError("Unexpected runtime error.")
      }
    
    
  return String(upDownOutput.position)
    
    
  print("RepModel: return 0 end")
  return ("NULL")
  }
  
  
}



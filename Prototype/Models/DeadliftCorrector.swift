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
    var leftHip = KeyPoint.init(bodyPart: .leftHip).coordinate
    var rightHip = KeyPoint.init(bodyPart: .rightHip).coordinate
    var rightAnkle = KeyPoint.init(bodyPart: .rightAnkle).coordinate
    var leftAnkle = KeyPoint.init(bodyPart: .leftAnkle).coordinate
    var leftShoulder = KeyPoint.init(bodyPart: .leftShoulder).coordinate
    var nose = KeyPoint.init(bodyPart: .nose).coordinate
    
    var needCorrectionParts = [needCorrectionPart]()
    
    for (index, part) in BodyPart.allCases.enumerated() {
      
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
        leftShoulder = result.keyPoints[index].coordinate
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
        leftHip = result.keyPoints[index].coordinate
      }
    }
    
    ///All correction only consider left side of body
    
    ///For pts. 1, 2 and 3; referring to the squat journal by Myer et al. (2014). Lacking a toe keypoint in MoveNet
    var partCorrection: needCorrectionPart = needCorrectionPart()
    
    /*
    if (nose.y - leftKnee.y) <= 20 {
      
      partCorrection.bodyPart = .nose
      partCorrection.direction = Direction.up
      
      needCorrectionParts.append(partCorrection)
      
    }*/
    
    
      
      let slopeLeg = (leftKnee.y - leftAnkle.y) / (leftKnee.x - leftAnkle.x)
      let slopeThigh = (leftHip.y - leftKnee.y) / (leftHip.x-leftKnee.x)
      let slopeThorax = (leftShoulder.y - leftHip.y) / (leftShoulder.x-leftHip.x)
      
      let angleKnee = atan( (slopeLeg - slopeThigh) ) // / (1 + slopeLeg*slopeThigh ) )
      
      print ("angleKnee: ", angleKnee)
      
      if angleKnee > ((100 )*Double.pi)/180 && angleKnee < ((170 )*Double.pi)/180 { // need to get threshold for kneepit angle; coincide with leftHip.y+150 >= leftKnee.y -> if that condition is true, then this condition is false
        
        print("In knee")
        partCorrection.bodyPart = .leftHip
        partCorrection.direction = Direction.down
        
        needCorrectionParts.append(partCorrection)
      }
    
      
    /// At bottom angles
    if leftHip.y+150 >= leftKnee.y { // need to get threshold for bottom position; should get from model but no time
      
      let angleHip = atan ( (slopeLeg - slopeThorax ) / (1 + slopeLeg*slopeThorax ) )
      
      print ("angleHip: ", angleHip)
      
      if angleHip < ((60 )*Double.pi)/180 { // need to get threshold for hippit angle
        
        print("In hip")
        partCorrection.bodyPart = .leftShoulder
        partCorrection.direction = Direction.up
        
        needCorrectionParts.append(partCorrection)
        
      }
      
      
    }
    
    
    print("needCorrectionParts: ", needCorrectionParts)
    return (needCorrectionParts)
    
    
    
    
  print("RepModel: return 0 end")
  return ([])
  }
  
  
}



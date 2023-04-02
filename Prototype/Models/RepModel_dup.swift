//
//  RepModel_dup.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 3/31/23.
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
    let upDownModel = SquatPosition_Three()
    
    /*
    guard let upDownOutput = try? upDownModel.prediction(x0: nose.coordinate.x/390, y0: nose.coordinate.y/668, c0: Double(nose.score),
                                                         x1: leftEye.coordinate.x/390, y1: leftEye.coordinate.y/668, c1: Double(leftEye.score),
                                                         x2: rightEye.coordinate.x/390, y2: rightEye.coordinate.y/668, c2: Double(rightEye.score),
                                                         x3: leftEar.coordinate.x/390, y3: leftEar.coordinate.y/668, c3: Double(leftEar.score),
                                                         x4: rightEar.coordinate.x/390, y4: rightEar.coordinate.y/668, c4: Double(rightEar.score),
                                                         x5: leftShoulder.coordinate.x/390, y5: leftShoulder.coordinate.y/668, c5: Double(leftShoulder.score),
                                                         x6: rightShoulder.coordinate.x/390, y6: rightShoulder.coordinate.y/668, c6: Double(rightShoulder.score),
                                                         x7: leftElbow.coordinate.x/390, y7: leftElbow.coordinate.y/668, c7: Double(leftElbow.score),
                                                         x8: rightElbow.coordinate.x/390, y8: rightElbow.coordinate.y/668, c8: Double(rightElbow.score),
                                                         x9: leftWrist.coordinate.x/390, y9: leftWrist.coordinate.y/668, c9: Double(leftWrist.score),
                                                         x10: rightWrist.coordinate.x/390, y10: rightWrist.coordinate.y/668, c10: Double(rightWrist.score),
                                                         x11: leftHip.coordinate.x/390, y11: leftHip.coordinate.y/668, c11: Double(leftHip.score),
                                                         x12: rightHip.coordinate.x/390, y12: rightHip.coordinate.y/668, c12: Double(rightHip.score),
                                                         x13: leftKnee.coordinate.x/390, y13: leftKnee.coordinate.y/668, c13: Double(leftKnee.score),
                                                         x14: rightKnee.coordinate.x/390, y14: rightKnee.coordinate.y/668, c14: Double(rightKnee.score),
                                                         x15: leftAnkle.coordinate.x/390, y15: leftAnkle.coordinate.y/668, c15: Double(leftAnkle.score),
                                                         x16: rightAnkle.coordinate.x/390, y16: rightAnkle.coordinate.y/668, c16: Double(rightAnkle.score))
    else {
        fatalError("Unexpected runtime error.")
    }
    */
    
    var length = pow( (leftShoulder.coordinate.x - leftHip.coordinate.x), 2 ) + pow( (leftShoulder.coordinate.y - leftHip.coordinate.y), 2 )
    length = sqrt(length)
    
    
    guard let upDownOutput = try? upDownModel.prediction(x_ls_le_l: Double(leftShoulder.coordinate.x - leftElbow.coordinate.x)/length,
                                                         y_ls_le_l: Double(leftShoulder.coordinate.y - leftElbow.coordinate.y)/length,
                                                         x_ls_le_r: Double(rightShoulder.coordinate.x - rightElbow.coordinate.x)/length,
                                                         y_ls_le_r: Double(rightShoulder.coordinate.y - rightElbow.coordinate.y)/length,
                                                         x_le_lw_l: Double(leftElbow.coordinate.x - leftWrist.coordinate.x)/length,
                                                         y_le_lw_l: Double(leftElbow.coordinate.y - leftWrist.coordinate.y)/length,
                                                         x_le_lw_r: Double(rightElbow.coordinate.x - rightWrist.coordinate.x)/length,
                                                         y_le_lw_r: Double(rightElbow.coordinate.y - rightWrist.coordinate.y)/length,
                                                         x_ls_lh_l: Double(leftShoulder.coordinate.x - leftHip.coordinate.x)/length,
                                                         y_ls_lh_l: Double(leftShoulder.coordinate.y - leftHip.coordinate.y)/length,
                                                         x_ls_lh_r: Double(rightShoulder.coordinate.x - rightHip.coordinate.x)/length,
                                                         y_ls_lh_r: Double(rightShoulder.coordinate.y - rightHip.coordinate.y)/length,
                                                         x_lh_lk_l: Double(leftHip.coordinate.x - leftKnee.coordinate.x)/length,
                                                         y_lh_lk_l: Double(leftHip.coordinate.y - leftKnee.coordinate.y)/length,
                                                         x_lh_lk_r: Double(rightHip.coordinate.x - rightKnee.coordinate.x)/length,
                                                         y_lh_lk_r: Double(rightHip.coordinate.y - rightKnee.coordinate.y)/length,
                                                         x_lk_la_l: Double(leftKnee.coordinate.x - leftAnkle.coordinate.x)/length,
                                                         y_lk_la_l: Double(leftKnee.coordinate.y - leftAnkle.coordinate.y)/length,
                                                         x_lk_la_r: Double(rightKnee.coordinate.x - rightAnkle.coordinate.x)/length,
                                                         y_lk_la_r: Double(rightKnee.coordinate.y - rightAnkle.coordinate.y)/length,
                                                         length: Double(length))
    else {
        fatalError("Unexpected runtime error.")
    }
    
    
    
    print("**********start*********")
    print("Double(leftShoulder.coordinate.x - leftElbow.coordinate.x)/length: ",Double(leftShoulder.coordinate.x - leftElbow.coordinate.x)/length)
    print("Double(leftShoulder.coordinate.y - leftElbow.coordinate.y)/length: ",Double(leftShoulder.coordinate.y - leftElbow.coordinate.y)/length)
    /*
    print("leftEar.coordinate: ",leftEar.coordinate)
    print("rightEar.coordinate: ",rightEar.coordinate)
    print("leftShoulder.coordinate: ",leftShoulder.coordinate)
    print("rightShoulder.coordinate: ",rightShoulder.coordinate)
    print("leftElbow.coordinate: ",leftElbow.coordinate)
    print("rightElbow.coordinate: ",rightElbow.coordinate)
    print("leftWrist.coordinate: ",leftWrist.coordinate)
    print("rightWrist.coordinate: ",rightWrist.coordinate)*/
    
    print("Double(leftHip.coordinate.x - leftKnee.coordinate.x)/length: ",Double(leftHip.coordinate.x - leftKnee.coordinate.x)/length)
    print("Double(leftHip.coordinate.y - leftKnee.coordinate.y)/length: ",Double(leftHip.coordinate.y - leftKnee.coordinate.y)/length)
    /*
    print("leftKnee.coordinate: ",leftKnee.coordinate)
    print("rightKnee.coordinate: ",rightKnee.coordinate)
    print("leftAnkle.coordinate: ",leftAnkle.coordinate)
    print("rightAnkle.coordinate: ",rightAnkle.coordinate)*/
    print("**********end*********")
    
    
    return String(upDownOutput.position)
    
    /*
    let hipHeight = rightHip.y
    let kneeHeight = rightKnee.y
    if hipHeight <= kneeHeight {
      //self.wasInBottomPosition = true
      return ("1 top")
    } else {
      return ("0 down")
    }*/
    
  print("RepModel: return 0 end")
  return ("NULL")
  }
  
  
}


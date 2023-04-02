//
//  RepEstimator.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 3/19/23.
//

import UIKit

/// Protocol to  run a repetition estimator.
protocol RepetitionEstimator {
  func estimateRepetition(on result: Person) throws -> (String)
  
}


/*
// MARK: - Custom Errors
enum PoseEstimationError: Error {
  case modelBusy
  case preprocessingFailed
  case inferenceFailed
  case postProcessingFailed
}
*/
//
//  CorrectionEstimator.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 4/11/23.
//

import UIKit

/// Protocol to  run a correction estimator.
protocol CorrectionEstimator {
  func estimateCorrection(on result: Person) throws -> ([needCorrectionPart])
  
}

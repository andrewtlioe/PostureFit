//
//  ViewController_Dup.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 3/21/23.
//

import AVFoundation
import UIKit
import os
import SwiftUI


final class ViewController: UIViewController {
  
  // MARK: Storyboards Connections
  @IBOutlet private weak var overlayView: OverlayView!
  @IBOutlet private weak var threadStepperLabel: UILabel!
  @IBOutlet private weak var threadStepper: UIStepper!
  @IBOutlet private weak var totalTimeLabel: UILabel!
  @IBOutlet private weak var scoreLabel: UILabel!
  @IBOutlet private weak var keypointLabel: UILabel!
  @IBOutlet private weak var delegatesSegmentedControl: UISegmentedControl!
  @IBOutlet private weak var modelSegmentedControl: UISegmentedControl!
  
  @IBOutlet private weak var repetitionCounter: UILabel!
  @IBOutlet private weak var timerLabel: UILabel!
  
  
  // MARK: Pose estimation model configs
  private var modelType: ModelType = Constants.defaultModelType
  private var threadCount: Int = Constants.defaultThreadCount
  private var delegate: Delegates = Constants.defaultDelegate
  private let minimumScore = Constants.minimumScore

  // MARK: Visualization
  // Relative location of `overlayView` to `previewView`.
  private var imageViewFrame: CGRect?
  // Input image overlaid with the detected keypoints.
  var overlayImage: OverlayView?
  private var cameraBackSide = Constants.defaultCameraBackSide

  // MARK: Controllers that manage functionality
  // Handles all data preprocessing and makes calls to run inference.
  private var poseEstimator: PoseEstimator?
  private var cameraFeedManager: CameraFeedManager!
  private var repetitionEstimator: RepetitionEstimator?
  private var cameraSwitcher: CameraSwitcher?
  //private var timer: Timer
  
  private var timer: Timer = Timer()
  var count:Int = 0
  var timerCounting:Bool = false

  // Serial queue to control all tasks related to the TFLite model.
  let queue = DispatchQueue(label: "serial_queue")

  // Flag to make sure there's only one frame processed at each moment.
  var isRunning = false

  // MARK: View Handling Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    updateModel()
    //updateCamera()
    configCameraCapture()
    initializeCountEstimator()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //print("overlayImage?.frame.size", overlayImage?.frame.size)
    //print("overlayView.frame.size ", overlayView.frame.size)
    cameraFeedManager?.startRunning()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    cameraFeedManager?.stopRunning()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    imageViewFrame = overlayView.frame
  }

  private func configCameraCapture() {
    cameraFeedManager = CameraFeedManager(cameraBackSide: self.cameraBackSide)
    cameraFeedManager.startRunning()
    cameraFeedManager.delegate = self
  }
  
  private func initializeCountEstimator() {
    self.repetitionEstimator = RepModel()
  }
  
  /// Call this method when there's change in camera selection config
  /// or updating runtime config.
  private func updateCamera() {
    
    //print ("In updateCamera()")
    // Update the camera in the same serial queue with the inference logic to avoid race condition
    queue.async {
      do {
        
        if self.cameraBackSide{
          self.cameraBackSide = false
        } else {
          self.cameraBackSide = true
        }
        
        self.configCameraCapture() // switch camera
        
      } catch let error {
        os_log("Error: %@", log: .default, type: .error, String(describing: error))
      }
    }
    
  }
  

  /// Call this method when there's change in pose estimation model config, including changing model
  /// or updating runtime config.
  private func updateModel() {
    // Update the model in the same serial queue with the inference logic to avoid race condition
    queue.async {
      do {
        switch self.modelType {
        case .posenet:
          self.poseEstimator = try PoseNet(
            threadCount: self.threadCount,
            delegate: self.delegate)
        case .movenetLighting, .movenetThunder:
          self.poseEstimator = try MoveNet(
            threadCount: self.threadCount,
            delegate: self.delegate,
            modelType: self.modelType)
        }
      } catch let error {
        os_log("Error: %@", log: .default, type: .error, String(describing: error))
      }
    }
  }

  @IBAction private func threadStepperValueChanged(_ sender: UIStepper) {
    threadCount = Int(sender.value)
    threadStepperLabel.text = "\(threadCount)"
    updateModel()
  }
  @IBAction private func delegatesValueChanged(_ sender: UISegmentedControl) {
    delegate = Delegates.allCases[sender.selectedSegmentIndex]
    updateModel()
  }

  @IBAction private func modelTypeValueChanged(_ sender: UISegmentedControl) {
    modelType = ModelType.allCases[sender.selectedSegmentIndex]
    updateModel()
  }
  
  @IBAction func SwitchCamera(_ sender: UIButton) {
    updateCamera()
  }
  
  
}




// MARK: - CameraFeedManagerDelegate Methods
extension ViewController: CameraFeedManagerDelegate {
  func cameraFeedManager(
    _ cameraFeedManager: CameraFeedManager, didOutput pixelBuffer: CVPixelBuffer
  ) {
    self.runModel(pixelBuffer)
  }
  
  /// Run pose estimation on the input frame from the camera.
  private func runModel(_ pixelBuffer: CVPixelBuffer) {
    // Guard to make sure that there's only 1 frame process at each moment.
    guard !isRunning else { return }

    // Guard to make sure that the pose estimator is already initialized.
    guard let estimator = poseEstimator else { return }
    
    // Run inference on a serial queue to avoid race condition.
    queue.async {
      self.isRunning = true
      defer { self.isRunning = false }
      
      //print("self.startTimer()")
      self.startTimer()
      
      // Run pose estimation
      do {
        let (result, _ ) = try estimator.estimateSinglePose(
            on: pixelBuffer)

        // Return to main thread to show detection results on the app UI.
        DispatchQueue.main.async {
          
          // Allowed to set image and overlay
          let image = UIImage(ciImage: CIImage(cvPixelBuffer: pixelBuffer))

          // If score is too low, clear result remaining in the overlayView.
          if result.score < self.minimumScore {
            self.overlayView.image = image
            return
          }
          
          print("overlayImage?.frame.size", self.overlayImage?.frame.size)
          print("overlayView.frame.size ", self.overlayView.frame.size)
          
          // Visualize the pose estimation result.
          print("ViewController_dup: overlayView.draw")
          self.overlayView.draw(at: image, person: result)
          
          // possible location for arrow drawing
          
        }
        
        // possible location for counter implementation
        let count = self.runCounter(person: result)
        
      } catch {
        os_log("Error running pose estimation.", type: .error)
        return
      }
    }
    
    self.stopTimer()
  }
  
  
  private func runCounter(person: Person) {
    print("ViewController_dup: In runCounter")
    // Guard to make sure that the repetition estimator is already initialized.
    guard let repEstimator = repetitionEstimator else { print ("return"); return }
    
    // Run inference with concurrency to run multiple functions on screen. Currently only pose estimation and repetition estimation
    do {
      //upDown return 0/1 for up or down position for testing currently
      let upDown = try repEstimator.estimateRepetition(
        on: person)
      
      DispatchQueue.main.async {
        // Return up/down values to show in StoryBoard
        print("upDown: ", upDown)
        self.repetitionCounter.text = String(upDown) //String (format: "%@", arguments: [upDown])
      }
      
    } catch {
      os_log("Error running counter estimation.", type: .error)
    }
    
  }
  
  
  private func startTimer (){
    //print("In startTimer()")
    timerCounting = true
    DispatchQueue.main.async {
      self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCounter), userInfo: nil, repeats: true)
    }
  }
  
  private func stopTimer (){
    //print("In stopTimer()")
    timerCounting = false
    DispatchQueue.main.async {
      self.timer.invalidate()
    }
  }
  
  @objc func timerCounter() -> Void
    {
      //print("In timerCounter()")
      count = count + 1
      let time = self.secondsToHoursMinutesSeconds(seconds: count)
      let timeString = self.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
      self.timerLabel.text = String(timeString)
      //print(timeString)
    }
  
  func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
    {
      return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
    }
    
  func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
    {
      var timeString = ""
      timeString += String(format: "%02d", hours)
      timeString += " : "
      timeString += String(format: "%02d", minutes)
      timeString += " : "
      timeString += String(format: "%02d", seconds)
      return timeString
    }
  
  
}


// default settings
enum Constants {
  // Configs for the TFLite interpreter.
  static let defaultThreadCount = 4
  static let defaultDelegate: Delegates = .gpu
  static let defaultModelType: ModelType = .movenetLighting

  // Minimum score to render the result.
  static let minimumScore: Float32 = 0.2
  
  // default camera setting
  static let defaultCameraBackSide = true
}


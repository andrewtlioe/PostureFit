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
  
  // MARK: Rep/Corr estimation model configs
  private var repCorModelType = Constants.defaultRepCorrModelType
  
  //Pass movement type from button pressed in TrainerMenuView
  var selectedPosition: String = Constants.defaultSelectedPosition // default to "Squat"

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
  
  private var correctionEstimator: CorrectionEstimator?
  
  private var cameraSwitcher: CameraSwitcher?
  
  
  // test
  private var needCorrectionParts = needCorrectionPart()
  private var needCorrectionParts2 = needCorrectionPart()
  private var needCorrectionParts3 = needCorrectionPart()
  private var needCorrectionParts4 = needCorrectionPart()
  private var needCorrectionParts5 = needCorrectionPart()
  
  //private var repetitionCounter: Int = 0
  
  //private var timer: Timer
  
  private var timer: Timer = Timer()
  var count:Int = 0
  var timerCounting:Bool = false
  
  
  var estimate = [0,0,0,0,0,0,0,0,0,0]
  var prevUpDown = 0.0
  var counter = 0
  let synth = AVSpeechSynthesizer ()
  let windowAccuracy = 0.5

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
    initializeEstimators()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.isIdleTimerDisabled = true
    cameraFeedManager?.startRunning()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIApplication.shared.isIdleTimerDisabled = false
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
  
  private func initializeEstimators() {
    if (self.selectedPosition == "Squat") {
      self.repetitionEstimator = SquatModel_Controller() //for squat
      self.correctionEstimator = SquatCorrector()
    } else {
      self.repetitionEstimator = DeadliftModel_Controller() //for squat
      self.correctionEstimator = DeadliftCorrector() //change to DeadliftCorrector() when ready
    }
  }
  
  /// Call this method when there's change in camera selection config
  /// or updating runtime config.
  private func updateCamera() {
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
  
  private func resetCounter(){
    queue.async{
      do{
        self.counter = 0
      }
    }
  }
  
  /// Call this method to change repcorrmodel while in action
  private func updateRepModel() {
    // Update the model in the same serial queue with the inference logic to avoid race condition
    queue.async {
      do {
        switch self.repCorModelType {
        case .squat:
          self.repetitionEstimator = try SquatModel_Controller()
        case .deadlift:
          self.repetitionEstimator = try DeadliftModel_Controller()
        }
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
  
  
  @IBAction func ResetCounter(_ sender: UIButton) {
    resetCounter()
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
    
    print (self.selectedPosition)
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
          //self.overlayView.draw(at: image, person: result)
          
          
          
          
          
          
          //issue: left right body parts flipped when using front-facing camera
          
          self.needCorrectionParts.bodyPart = .nose
          self.needCorrectionParts.direction = Direction.up
          
          self.needCorrectionParts2.bodyPart = .rightEye
          self.needCorrectionParts2.direction = Direction.upRight
          
          self.needCorrectionParts3.bodyPart = .leftEye
          self.needCorrectionParts3.direction = Direction.upLeft
          
          self.needCorrectionParts4.bodyPart = .rightEar
          self.needCorrectionParts4.direction = Direction.downRight
          
          self.needCorrectionParts5.bodyPart = .leftEar
          self.needCorrectionParts5.direction = Direction.downLeft
          
          
          //self.overlayView.draw(at: image, person: result, needCorrectionParts: [self.needCorrectionParts, self.needCorrectionParts2, self.needCorrectionParts3, self.needCorrectionParts4, self.needCorrectionParts5]) //test arrow placement
          
          
          
          
          // possible location for arrow drawing
          //let count = self.runCounter(person: result)
          let correct = self.runCorrector(at: image, person: result) //slow
          
          
          
        }
        
        // possible location for counter implementation
        let count = self.runCounter(person: result)
        
        //let correct = self.runCorrector(at: image, person: result)
        
      } catch {
        os_log("Error running pose estimation.", type: .error)
        return
      }
    }
    
    self.stopTimer()
  }
  
  
  
  
  
  
  private func runCorrector(at image: UIImage, person: Person) {
    print("ViewController_dup: In runCorrector")
    
    // Guard to make sure that the repetition estimator is already initialized.
    guard let correctionEstimator = correctionEstimator else { print ("return"); return } // need to have struct intermediate for both movements; not running
    
    //self.squatCorrector.estimateCorrection(on: person)
    
    // Run inference with concurrency to run multiple functions on screen. Currently only pose estimation and repetition estimation
    do {
      //upDown return 0/1 for up or down position for testing currently
      let correction = try correctionEstimator.estimateCorrection(on: person) //returns type [needCorrectionPart]

      DispatchQueue.main.async {
        // Draw arrows to show in StoryBoard
        
        
        self.overlayView.draw(at: image, person: person, needCorrectionParts: correction) //test arrow placement
      }
      
      
    } catch {
      os_log("Error running counter estimation.", type: .error)
    }
    
  }
  
  
  
  
  
  
  
  /*
  
  private func runCounter(person: Person) {
    print("ViewController_dup: In runCounter")
    
    // Guard to make sure that the repetition estimator is already initialized.
    guard let repEstimator = repetitionEstimator else { print ("return"); return } //how to add deadlift too
    
    // array to store returned values in upDown for Majority Voting
    var voteRepetitionCounter = [Int](repeating: 0, count: 10)
    
    // Run inference with concurrency to run multiple functions on screen. Currently only pose estimation and repetition estimation
    do {
      //upDown return 0/1 for up or down position for testing currently
      let upDown = try repEstimator.estimateRepetition(
        on: person)
      
      
      
      DispatchQueue.main.async {
        // Return up/down values to show in StoryBoard
        
        print("upDown: ", upDown)
        
        //voteRepetitionCounter.append(Int(upDown)!) //force unwrap to Int
        
        //let counts = voteRepetitionCounter.reduce(into: [:]) { counts, updown in counts[updown, default: 0] += 1 }
        
        self.repetitionCounter.text = String(upDown)
      }
      
      
    } catch {
      os_log("Error running counter estimation.", type: .error)
    }
    
  }
   
  */
  
  
  
  
  
  private func runCounter(person: Person) {
    print("ViewController_dup: In runCounter")
    
    // Guard to make sure that the repetition estimator is already initialized.
    guard let repEstimator = repetitionEstimator else { print ("return"); return } //how to add deadlift too
    
    // array to store returned values in upDown for Majority Voting
    var voteRepetitionCounter = [Int](repeating: 0, count: 10)
    
    // Run inference with concurrency to run multiple functions on screen. Currently only pose estimation and repetition estimation
    do {
      //upDown return 0/1 for up or down position for testing currently
      let upDown = try repEstimator.estimateRepetition(
        on: person)
      
      
      
      DispatchQueue.main.async {
        // Return up/down values to show in StoryBoard
        self.estimate.removeFirst(1)
        self.estimate.append (Int (upDown) ?? 0)
        let sumArray = self.estimate.reduce (0, +)
        let avgArrayValue = Double (sumArray) / Double (self.estimate.count)
        
        if self.prevUpDown >= self.windowAccuracy && avgArrayValue < self.windowAccuracy {
          self.counter += 1
          let string = String(self.counter)
          if MyVariables.voiceCounter {
            let utterance = AVSpeechUtterance (string: string)
            utterance.voice = AVSpeechSynthesisVoice (language: "en-US")
            self.synth.speak(utterance)
          }
        }
        self.prevUpDown = avgArrayValue
        
        self.repetitionCounter.text = String(self.counter)
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
  
  // Configs for the rep/corr estimation model
  static let defaultRepCorrModelType: repCorModelType = .squat

  // Minimum score to render the result.
  static let minimumScore: Float32 = 0.2
  
  // default camera setting
  static let defaultCameraBackSide = true
  // default camera setting
  static let defaultSelectedPosition = "Squat"
}


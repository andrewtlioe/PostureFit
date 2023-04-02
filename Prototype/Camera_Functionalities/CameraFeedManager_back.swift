//
//  CameraFeedManager_back.swift
//  PostureFit
//
//  Created by Andrew Tian Lioe on 3/26/23.
//

import AVFoundation
import Accelerate.vImage
import UIKit

/// Delegate to receive the frames captured from the device's camera.
protocol CameraFeedManagerDelegateBack: AnyObject {

  /// Callback method that receives frames from the camera.
  /// - Parameters:
  ///     - cameraFeedManager: The CameraFeedManager instance which calls the delegate.
  ///     - pixelBuffer: The frame received from the camera.
  func cameraFeedManagerBack(
    _ cameraFeedManagerBack: cameraFeedManagerBack, didOutput pixelBuffer: CVPixelBuffer)
}

/// Manage the camera pipeline.
final class cameraFeedManagerBack: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, CameraSwitcher {

  /// Delegate to receive the frames captured by the device's camera.
  var delegate: CameraFeedManagerDelegateBack?

  override init() {
    super.init()
    configureSession()
  }

  /// Start capturing frames from the camera.
  func startRunning() {
    captureSession.startRunning()
  }

  /// Stop capturing frames from the camera.
  func stopRunning() {
    captureSession.stopRunning()
  }
  
  let captureSession = AVCaptureSession()  
  

  /// Initialize the capture session.
  private func configureSession() {
    captureSession.sessionPreset = AVCaptureSession.Preset.photo

    guard
      let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    else {
      return
    }
    
    
    do {
      let input = try AVCaptureDeviceInput(device: backCamera)
      captureSession.addInput(input)
    } catch {
      return
    }

    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.videoSettings = [
      (kCVPixelBufferPixelFormatTypeKey as String): NSNumber(value: kCVPixelFormatType_32BGRA)
    ]
    videoOutput.alwaysDiscardsLateVideoFrames = true
    let dataOutputQueue = DispatchQueue(
      label: "video data queue",
      qos: .userInitiated,
      attributes: [],
      autoreleaseFrequency: .workItem)
    if captureSession.canAddOutput(videoOutput) {
      captureSession.addOutput(videoOutput)
      videoOutput.connection(with: .video)?.videoOrientation = .portrait
      //videoOutput.connection(with: .video)?.isVideoMirrored = true // activate for front camera
      captureSession.startRunning()
    }
    videoOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
  }

  // MARK: Methods of the AVCaptureVideoDataOutputSampleBufferDelegate
  func captureOutput(
    _ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
    delegate?.cameraFeedManagerBack(self, didOutput: pixelBuffer)
    CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
  }
}

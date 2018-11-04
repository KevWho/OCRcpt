//
//  ScannerViewController.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

protocol ScannerViewDelegate {
    func useImage(_ image: UIImage!)
}

class ScannerViewController: UIViewController {
    
    @IBOutlet var previewView: UIView!
    
    let captureSession = AVCaptureSession()
    let deviceOutput = AVCapturePhotoOutput()
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var delegate: ScannerViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.back)
        
        var deviceInput: AVCaptureDeviceInput!
        do {
            guard let device = captureDevice else { return }
            deviceInput = try AVCaptureDeviceInput(device: device)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
            return
        };
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(deviceOutput)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = previewView.layer.frame
        previewView.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    
    @IBAction func getImage() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.flashMode = .auto
        deviceOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    @IBAction func tappedBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ScannerViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let cgImage = photo.cgImageRepresentation()!.takeRetainedValue()
        let image = UIImage(cgImage: cgImage, scale: 1, orientation: .up)
        
        if self.delegate != nil {
            self.delegate?.useImage(image)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

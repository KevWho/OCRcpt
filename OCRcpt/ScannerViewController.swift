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

class ScannerViewController: UIViewController {
    
    @IBOutlet var previewView: UIView!
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCapturePhotoOutput()
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession.sessionPreset = AVCaptureSession.Preset.photo
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
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = previewView.layer.frame
        previewView.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

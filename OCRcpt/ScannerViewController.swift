//
//  ScannerViewController.swift
//  OCRcpt
//
//  Created by Kevin Hu on 11/3/18.
//  Copyright © 2018 hu. All rights reserved.
//

import UIKit
import BlinkReceipt

class ScannerViewController: UIViewController {
    
    var results: BRScanResults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        let options = BRScanOptions()
        BRScanManager.shared().startStaticCamera(from: self, scanOptions: options, with: self)
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

extension ScannerViewController: BRScanResultsDelegate {
    func didFinishScanning(_ cameraViewController: UIViewController!, with scanResults: BRScanResults!) {
        cameraViewController.dismiss(animated: true, completion: nil)
        
        results = scanResults
    }
}

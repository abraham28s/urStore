//
//  AgregarACompraViewController.swift
//  urStore
//
//  Created by Javier Esponda on 3/21/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class AgregarACompraViewController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate{
    
    var scan = BarcodeScannerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func camaraPress(_ sender: UIButton) {
        scan.reset()
        scan.errorDelegate = self
        scan.dismissalDelegate = self
        scan.codeDelegate = self
        present(scan, animated: true,completion:nil)
    }
    
    ///////////Protocolos
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
    }
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print("Error al capturar codigo")
    }
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        print("se cerro")
    }
    
    ////////////////////

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

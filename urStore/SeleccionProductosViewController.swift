//
//  SeleccionProductosViewController.swift
//  urStore
//
//  Created by Abraham Soto on 14/02/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class SeleccionProductosViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate,BarcodeScannerDismissalDelegate {
    
    @IBOutlet weak var TablaProductos: UITableView!
    var scan = BarcodeScannerController()
    let ArregloProductos = [[1,"Coca-Cola",4,32.00],[2,"Pepsi",2,16.00],[3,"Fanta",6,48.00]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TablaProductos.delegate = self
        TablaProductos.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func cameraPress(_ sender: Any) {
        scan.reset()
        scan.errorDelegate = self
        scan.dismissalDelegate = self
        scan.codeDelegate = self
        present(scan, animated: true,completion:nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArregloProductos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CeldaProForProductTables(clave: String(describing: ArregloProductos[indexPath.row][0]), descripcion: ArregloProductos[indexPath.row][1] as! String, cantidad: String(describing: ArregloProductos[indexPath.row][2]), total: String(describing: ArregloProductos[indexPath.row][3]))
        
        return cell
    }
    
    ///////////Protocolos
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
    }
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print("Error al capturar codigo")
    }
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        scan.dismiss(animated: true, completion: nil)
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

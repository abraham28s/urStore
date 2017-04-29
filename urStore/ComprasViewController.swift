//
//  ComprasViewController.swift
//  urStore
//
//  Created by Abraham Soto on 27/04/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class ComprasViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate,BarcodeScannerDismissalDelegate {
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var RegistroProductosTable: UITableView!
    var scan = BarcodeScannerController()
    var Arreglo:[[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RegistroProductosTable.delegate = self
        RegistroProductosTable.dataSource = self
        tabla.allowsMultipleSelection = false
        tabla.allowsSelection = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabla.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func agregarACompra(producto:[String]){
        self.Arreglo.append(producto)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Arreglo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let total = Double(Arreglo[indexPath.row][4])! * Double(Arreglo[indexPath.row][2])!
        let cell = CeldaProForProductTables(nombre: Arreglo[indexPath.row][1], cantidad: Arreglo[indexPath.row][4], precio: "\(total)")
        
        return cell
    }
    
    
    @IBAction func pressCamera(_ sender: Any) {
        scan.reset()
        scan.errorDelegate = self
        scan.dismissalDelegate = self
        scan.codeDelegate = self
        present(scan, animated: true,completion:nil)
    }
    
    //////////Protocolos
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

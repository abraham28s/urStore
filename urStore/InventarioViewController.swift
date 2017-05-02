//
//  InventarioViewController.swift
//  urStore
//
//  Created by Abraham Soto on 14/02/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class InventarioViewController:  UIViewController,UITableViewDelegate,UITableViewDataSource,BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate  {
    
    @IBOutlet weak var tablaProductos: UITableView!
    @IBOutlet weak var codigoTxt: UITextField!
    @IBOutlet weak var nombreTxt: UITextField!
    var scan = BarcodeScannerController()
    let DB:DataBase = DataBase()
    var Arreglo:[[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DB.inicializar(){
            print("Éxito con base en Inventario")
        }
        let clause = "WHERE a.idProducto = b.id and b.esCaja = 'no'"
        Arreglo = DB.selectFrom(table: "\(DB.inventario) a, \(DB.productos) b", columnas: "a.idProducto,a.cantidad,b.nombre,b.precioVenta", whereClause: clause)
        tablaProductos.delegate = self
        tablaProductos.dataSource = self
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func tapEnPantalla(){
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    @IBAction func pressCamera(_ sender: Any) {
        scan.reset()
        scan.errorDelegate = self
        scan.dismissalDelegate = self
        scan.codeDelegate = self
        present(scan, animated: true,completion:nil)
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        scan.dismiss(animated: true, completion: nil)
        
        codigoTxt.text = code
        
        
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print("Error al capturar código")
    }
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        scan.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func codigoChange(_ sender: UITextField) {
        let clause = "WHERE a.idProducto = b.id AND b.esCaja = 'no' AND b.codigoBarras like '\(sender.text!)%'"
        Arreglo = DB.selectFrom(table: "\(DB.inventario) a, \(DB.productos) b", columnas: "a.idProducto,a.cantidad,b.nombre,b.precioVenta", whereClause: clause)
        tablaProductos.reloadData()
    }
    
    @IBAction func nombreChange(_ sender: UITextField) {
        let clause = "WHERE a.idProducto = b.id AND b.esCaja = 'no' AND b.nombre like '\(sender.text!)%'"
        Arreglo = DB.selectFrom(table: "\(DB.inventario) a, \(DB.productos) b", columnas: "a.idProducto,a.cantidad,b.nombre,b.precioVenta", whereClause: clause)
        tablaProductos.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Arreglo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CeldaProForProductTables(nombre: Arreglo[indexPath.row][2], cantidad: Arreglo[indexPath.row][1], precio: Arreglo[indexPath.row][3])
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

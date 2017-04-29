//
//  AgregarACompraViewController.swift
//  urStore
//
//  Created by Javier Esponda on 3/21/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class RegistrarProductosViewController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var precioProductoTxt: UITextField!
    
    
    @IBOutlet weak var nombreTxt: UITextField!
    @IBOutlet weak var unidadTxt: UITextField!
    @IBOutlet weak var tablaMarcas: UITableView!
    
    @IBOutlet weak var CodigoPrincipalTxt: UITextField!
    @IBOutlet weak var BotonCodigoPrincipal: UIButton!
    
    var scan = BarcodeScannerController()
    var arregloMarcas:[[String]] = []
    let DB:DataBase = DataBase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaMarcas.delegate = self
        tablaMarcas.dataSource = self
        tablaMarcas.allowsMultipleSelection = false
        tablaMarcas.allowsSelection = true
        DB.inicializar()
        arregloMarcas = DB.selectFrom(table: DB.marcas, columnas: "idMarca, nombreMarca")
        tablaMarcas.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloMarcas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "2")
        cell.textLabel?.text = arregloMarcas[indexPath.row][1]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    ///////////Protocolos
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        scan.dismiss(animated: true, completion: nil)
        
        CodigoPrincipalTxt.text = code
        
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print("Error al capturar codigo")
    }
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        scan.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resgistrarPressed(_ sender: Any) {
        let tupla = validaCampos()
        if(tupla.valida){
            insertarProducto()
        }else{
            self.present(DB.alertaDefault(titulo: "Error", texto: tupla.errorLog), animated: true, completion: nil)
            
        }
    }
    
    func insertarProducto(){
        if(!ExisteCodigoBarras()){
            
            let codigoProducto = CodigoPrincipalTxt.text!
            let nombreProducto = nombreTxt.text!
            let unidadProducto = unidadTxt.text!
            let precioProducto = precioProductoTxt.text!
            let marcaProducto = arregloMarcas[(tablaMarcas.indexPathForSelectedRow?.row)!][0]
            
            if(!DB.insertarEnDB(tabla: DB.productos, columnas: "(nombreProducto,precioUnitario,codigoBarras,unidad,idMarca)", valores: "('\(nombreProducto)',\(precioProducto),'\(codigoProducto)','\(unidadProducto)',\(marcaProducto))")){
                print("Error al insertar Producto")
            }else{
                ///
                ///Desea Registrar Otro producto o ir a cajas o nada
                ///
            }
            //DB.insertarEnDB(tabla: DB.productos, columnas: "(nombreProducto,precioUnitario,codigoBarras,unidad,idMarca)", valores: <#T##String#>)
            
                
        }else{
            //Cambiar a compras!!
        }
    }
    
    func ExisteCodigoBarras()->Bool{
        let codigo1 = CodigoPrincipalTxt.text!
        let arregloConsultaProductos = DB.selectFrom(table: "Productos", columnas: "*", whereClause: "WHERE codigoBarras = \(codigo1)")
        
        return arregloConsultaProductos.count > 0
    }
    
    func validaCampos()->(valida:Bool,errorLog:String){
        var errorLog = ""
        if(CodigoPrincipalTxt.text == ""){
            errorLog = "\(errorLog)Codigo de barras no puede estar vacio\n"
        }
        if(nombreTxt.text == ""){
            errorLog = "\(errorLog)Nombre no puede estar vacio\n"
        }
        if(unidadTxt.text == ""){
            errorLog = "\(errorLog)Unidad no puede estar vacio\n"
        }
        if(precioProductoTxt.text == ""){
            errorLog = "\(errorLog)Precio producto no puede estar vacio\n"
        }
        if(tablaMarcas.indexPathForSelectedRow == nil){
            errorLog = "\(errorLog)Debe seleccionar una marca\n"
        }
        
        return (errorLog == "",errorLog)
    }
}

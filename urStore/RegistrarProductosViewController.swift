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
    
    @IBOutlet weak var precioVentaTxt: UITextField!
    
    @IBOutlet weak var nombreTxt: UITextField!
    @IBOutlet weak var unidadTxt: UITextField!
    @IBOutlet weak var tablaMarcas: UITableView!
    var ind:IndexPath = IndexPath()
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
        if DB.inicializar(){
            print("Éxito con DB en registrar producto")
        }
        arregloMarcas = DB.selectFrom(table: DB.marcas, columnas: "idMarca, nombreMarca")
        tablaMarcas.reloadData()
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: "7")
        cell.textLabel?.text = arregloMarcas[indexPath.row][1]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        ind = indexPath
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
        print("Error al capturar código")
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
            let precioVenta = precioVentaTxt.text!
            let marcaProducto = arregloMarcas[(tablaMarcas.indexPathForSelectedRow?.row)!][0]
            
            if(!DB.insertarEnDB(tabla: DB.productos, columnas: "(nombre,precioCompra,precioVenta,codigoBarras,unidad,idMarca,esCaja)", valores: "('\(nombreProducto)',\(precioProducto),\(precioVenta),'\(codigoProducto)','\(unidadProducto)',\(marcaProducto),'no')")){
                print("Error al insertar Producto")
            }else{
                ///
                ///Desea Registrar Otro producto o ir a cajas o nada
                ///
                let alert = UIAlertController(title: "Éxito", message: "El producto se ha registrado correctamente.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ir a Cajas", style: .default, handler: { action in
                    self.irAPantallaCon(titulo: "Registro de Cajas")
                }))
                alert.addAction(UIAlertAction(title: "Registrar otro producto", style: .default, handler: {action in
                    self.nombreTxt.text = ""
                    self.precioProductoTxt.text = ""
                    self.precioVentaTxt.text = ""
                    self.unidadTxt.text = ""
                    self.CodigoPrincipalTxt.text = ""
                    self.tablaMarcas.deselectRow(at: self.ind, animated: true)
                    self.tablaMarcas.cellForRow(at: self.ind)?.accessoryType = .none
                    
                }))
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
                    self.nombreTxt.text = ""
                    self.precioProductoTxt.text = ""
                    self.precioVentaTxt.text = ""
                    self.unidadTxt.text = ""
                    self.CodigoPrincipalTxt.text = ""
                    self.tablaMarcas.deselectRow(at: self.ind, animated: true)
                    self.tablaMarcas.cellForRow(at: self.ind)?.accessoryType = .none
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
           
            
                
        }else{
            //Cambiar a compras!!
        }
    }
    
    func irAPantallaCon(titulo:String)->Void{
        let padre = self.parent as! ViewController
        switch titulo {
        case "Compras":
            padre.cambiarHijo(identif: "ingresosSB")
            padre.tituloLbl.text = titulo
        case "Ventas":
            
            
            padre.cambiarHijo(identif: "ventasSB")
            padre.tituloLbl.text = titulo
        case "Inventario":
            padre.cambiarHijo(identif: "inventarioSB")
            padre.tituloLbl.text = titulo
        case "Compras Sugeridas":
            padre.cambiarHijo(identif: "comprasSugeridasSB")
            padre.tituloLbl.text = titulo
        case "Balance":
            padre.cambiarHijo(identif: "balanceSB")
            padre.tituloLbl.text = titulo
        case "Registro de Proveedores":
            padre.cambiarHijo(identif: "proveedoresSB")
            padre.tituloLbl.text = titulo
        case "Registro de Marcas":
            padre.cambiarHijo(identif: "marcasSB")
            padre.tituloLbl.text = titulo
        case "Registro de Productos":
            padre.cambiarHijo(identif: "registroSB")
            padre.tituloLbl.text = titulo
        case "Registro de Cajas":
            padre.cambiarHijo(identif: "registroCajasSB")
            padre.tituloLbl.text = titulo
        default:
            print("Nothing")
        }
    }
    
    func ExisteCodigoBarras()->Bool{
        let codigo1 = CodigoPrincipalTxt.text!
        let arregloConsultaProductos = DB.selectFrom(table: "Productos", columnas: "*", whereClause: "WHERE codigoBarras = \(codigo1) and esCaja = 'no'")
        
        return arregloConsultaProductos.count > 0
    }
    
    func validaCampos()->(valida:Bool,errorLog:String){
        var errorLog = ""
        if(CodigoPrincipalTxt.text == ""){
            errorLog = "\(errorLog)Código de barras no puede estar vacío\n"
        }
        if(nombreTxt.text == ""){
            errorLog = "\(errorLog)Nombre no puede estar vacío\n"
        }
        if(unidadTxt.text == ""){
            errorLog = "\(errorLog)Unidad no puede estar vacío\n"
        }
        if(precioProductoTxt.text == ""){
            errorLog = "\(errorLog)Precio compra no puede estar vacío\n"
        }
        if(precioVentaTxt.text == ""){
            errorLog = "\(errorLog)Precio venta no puede estar vacío\n"
        }
        if(tablaMarcas.indexPathForSelectedRow == nil){
            errorLog = "\(errorLog)Debe seleccionar una marca\n"
        }
        
        return (errorLog == "",errorLog)
    }
}

//
//  AgregarACompraViewController.swift
//  urStore
//
//  Created by Abraham Soto on 26/04/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class AgregarACompraViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    let DB:DataBase = DataBase()
    var scan = BarcodeScannerController()
    
    @IBOutlet weak var codigoTxt: UITextField!
    @IBOutlet weak var tablaProductos: UITableView!
    @IBOutlet weak var cantidadTxt: UITextField!
    var activeField:UITextField? = nil
    var arregloProductos:[[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaProductos.delegate = self
        tablaProductos.dataSource = self
        if DB.inicializar(){
            print("Éxito con la base en agregar a transaccion")
        }
        if(GlobalVariables.siEsCompraEsTrue){
            arregloProductos = DB.selectFrom(table: DB.productos, columnas: "id,nombre,precioCompra,codigoBarras,esCaja")
        }else{
            arregloProductos = DB.selectFrom(table: DB.productos, columnas: "id,nombre,precioVenta,codigoBarras,esCaja")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }
    @IBAction func txtGetFocus(_ sender: UITextField) {
        activeField = sender
    }
    
    @IBAction func txtLostFocus(_ sender: UITextField) {
        activeField = nil
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let kbSize = keyboardSize.size
            let contentInsets:UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            var aRect:CGRect = self.view.frame;
            aRect.size.height -= kbSize.height;
            if (!aRect.contains((activeField?.frame.origin)!) ) {
                self.scrollView.scrollRectToVisible((activeField?.frame)!, animated: true)
            }
            /*if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }*/
            }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    func tapEnPantalla(){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressHelp(_ sender: UIButton) {
        self.present(DB.alertaDefault(titulo: "Ayuda", texto: "1.Busca un producto con su nombre\n2.Seleccionalo en la tabla\n3.Escribe la cantidad a agregar\n4.Presiona Agregar Producto"), animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloProductos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "445")
        cell.textLabel?.text = arregloProductos[indexPath.row][1]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        codigoTxt.text = arregloProductos[indexPath.row][1]
    }
    
    @IBAction func pressAgregar(_ sender: UIButton) {
        
        let tupla = validaCampos()
        if(tupla.valida){
            arregloProductos[tablaProductos.indexPathForSelectedRow!.row].append(cantidadTxt.text!)
            
            agregarACompra()
        }else{
            self.present(DB.alertaDefault(titulo: "Error", texto: tupla.errorLog), animated: true, completion: nil)
            
        }
    }
    
    func agregarACompra(){
        if GlobalVariables.siEsCompraEsTrue{
            let papa = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2] as! ViewController
            let papaEspecifico = papa.currentViewController as! ComprasViewController
            papaEspecifico.agregarACompra(producto: arregloProductos[(tablaProductos.indexPathForSelectedRow?.row)!])
        }else{
            
            let papa = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2] as! ViewController
            let papaEspecifico = papa.currentViewController as! VentasViewController
            papaEspecifico.agregarACompra(producto: arregloProductos[(tablaProductos.indexPathForSelectedRow?.row)!])
            
        }
        self.navigationController?.popViewController(animated: true)

    }
    
    func validaCampos()->(valida:Bool,errorLog:String){
        var errorLog = ""
        if(tablaProductos.indexPathForSelectedRow == nil){
            errorLog = "\(errorLog)Debes seleccionar un producto\n"
        }
        if(cantidadTxt.text == ""){
            errorLog = "\(errorLog)Cantidad no puede estar vacío\n"
        }
        
        if(!GlobalVariables.siEsCompraEsTrue){
            //Checar que cantidad sea menor que stock
            let idProducto = arregloProductos[(tablaProductos.indexPathForSelectedRow?.row)!][0]
            
            
            
            if(arregloProductos[(tablaProductos.indexPathForSelectedRow?.row)!][4] == "si"){
                let cantidadActualArr = DB.selectFrom(table: DB.inventario, columnas: "cantidad",whereClause: "WHERE idProducto = \(idProducto)")
                var cantidadActual = 0
                if(cantidadActualArr.isEmpty){
                    cantidadActual = 0
                }else{
                    cantidadActual = Int(cantidadActualArr[0][0])!
                }
                
                if(Int(cantidadTxt.text!)! > cantidadActual){
                    errorLog = "\(errorLog)Cantidad no puede ser mayor que el stock actual, stock actual: \(cantidadActual)\n"
                }
                //Checar si los productos existen
                //Con id caja sacamos id producto y piezas
                let cajaData = DB.selectFrom(table: DB.cajas, columnas: "idProducto, cantidadEnCaja",whereClause: "WHERE idCaja = \(idProducto)")
                
                let cantidadActualProdArr = DB.selectFrom(table: DB.inventario, columnas: "cantidad",whereClause: "WHERE idProducto = \(cajaData[0][0])")
                var cantidadActualProd = 0
                if(cantidadActualProdArr.isEmpty){
                    cantidadActualProd = 0
                }else{
                    cantidadActualProd = Int(cantidadActualProdArr[0][0])!
                }
                if(Int(cajaData[0][1])! > cantidadActualProd){
                    errorLog = "\(errorLog)Cantidad que contiende la caja es mayor al stock actual del producto, stock actual: \(cantidadActualProd)\n"
                }
            }else{
                let cantidadActualArr = DB.selectFrom(table: DB.inventario, columnas: "cantidad",whereClause: "WHERE idProducto = \(idProducto)")
                var cantidadActual = 0
                if(cantidadActualArr.isEmpty){
                    cantidadActual = 0
                }else{
                    cantidadActual = Int(cantidadActualArr[0][0])!
                }
                
                if(Int(cantidadTxt.text!)! > cantidadActual){
                    errorLog = "\(errorLog)Cantidad no puede ser mayor que el stock actual, stock actual: \(cantidadActual)\n"
                }
            }
        }
        
        return (errorLog == "",errorLog)
    }
    
    @IBAction func nombreTxtonChange(_ sender: UITextField) {
        let clause = "WHERE nombre like '\(sender.text!)%'"
        if(GlobalVariables.siEsCompraEsTrue){
            arregloProductos = DB.selectFrom(table: DB.productos, columnas: "id,nombre,precioCompra,codigoBarras,esCaja", whereClause: clause)
        }else{
            arregloProductos = DB.selectFrom(table: DB.productos, columnas: "id,nombre,precioVenta,codigoBarras,esCaja", whereClause: clause)
        }
        
        tablaProductos.reloadData()
    }
    
    
    

}

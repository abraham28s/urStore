//
//  RegistrarCajaViewController.swift
//  urStore
//
//  Created by Abraham Soto on 25/04/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class RegistrarCajaViewController: UIViewController, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {

    var scan = BarcodeScannerController()
    let DB:DataBase = DataBase()
    
    @IBOutlet weak var CodigoPrincipalTxt: UITextField!
    @IBOutlet weak var precioTxt: UITextField!
    @IBOutlet weak var precioVentaTxt: UITextField!
    @IBOutlet weak var nombreTxt: UITextField!
    @IBOutlet weak var piezasTxt: UITextField!
    @IBOutlet weak var CodigoSecundarioTxt: UITextField!
    @IBOutlet weak var botonPrincipal: UIButton!
    @IBOutlet weak var botonSecundario: UIButton!
    var botonPressed: UIButton = UIButton()
    var activeField:UITextField? = nil

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DB.inicializar(){
            print("Éxito DB en registrar caja")
        }
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
            //print(activeField?.frame.origin)
            print(aRect.contains((activeField?.frame.origin)!))
            
            if ((activeField == nombreTxt || activeField == piezasTxt || activeField == CodigoSecundarioTxt) && self.view.frame.origin.y == 0){
                self.view.frame.origin.y -= keyboardSize.height
            }
            /*if self.view.frame.origin.y == 0{
             
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
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        scan.dismiss(animated: true, completion: nil)
        
        switch botonPressed {
        case botonPrincipal:
            CodigoPrincipalTxt.text = code
        case botonSecundario:
            CodigoSecundarioTxt.text = code
        default:
            print("Nothing")
        }
        
    }
    func ExisteCodigoBarras(tabla:String,codigo:String)->Bool{
        let arregloConsultaProductos = DB.selectFrom(table: tabla, columnas: "*", whereClause: "WHERE codigoBarras = '\(codigo)'")
        //print(arregloConsultaProductos.count)
        return arregloConsultaProductos.count > 0
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print("Error al capturar código")
    }
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        scan.dismiss(animated: true, completion: nil)
    }
    
    func validaCampos()->(valida:Bool,errorLog:String){
        var errorLog = ""
        if(CodigoPrincipalTxt.text == ""){
            errorLog = "\(errorLog)Código de barras no puede estar vacío\n"
        }
        if(precioTxt.text == ""){
            errorLog = "\(errorLog)Precio compra no puede estar vacío\n"
        }
        if(precioVentaTxt.text == ""){
            errorLog = "\(errorLog)Precio venta no puede estar vacío\n"
        }
        if(nombreTxt.text == ""){
            errorLog = "\(errorLog)Nombre no puede estar vacío\n"
        }
        if(piezasTxt.text == ""){
            errorLog = "\(errorLog)Piezas por Caja no puede estar vacío\n"
        }
        
        if(CodigoPrincipalTxt.text == CodigoSecundarioTxt.text){
            errorLog = "\(errorLog)El código de caja y código de producto no pueden ser iguales\n"
        }
        if(CodigoSecundarioTxt.text == ""){
            errorLog = "\(errorLog)Código de barras del producto no puede estar vacío\n"
        }
        
        return (errorLog == "",errorLog)
    }
    
    @IBAction func pressCamera(_ sender: UIButton) {
        scan.reset()
        scan.errorDelegate = self
        scan.dismissalDelegate = self
        scan.codeDelegate = self
        botonPressed = sender
        present(scan, animated: true,completion:nil)
    }
    
    func insertarProducto(){
        if(!ExisteCodigoBarras(tabla: DB.productos, codigo: CodigoPrincipalTxt.text!)){
            if(ExisteCodigoBarras(tabla: DB.productos, codigo: CodigoSecundarioTxt.text!)){
                
                let nombreCaja = nombreTxt.text!
                let precio = precioTxt.text!
                let producto = DB.selectFrom(table: DB.productos, columnas: "id", whereClause: "where codigoBarras = '\(CodigoSecundarioTxt.text!)' and esCaja = 'no'")
                let idProducto = producto[0][0]
                let cantidadEnCaja = piezasTxt.text!
                let idCaja = Int(DB.selectFrom(table: DB.productos, columnas: "MAX(id)")[0][0])! + 1
                
                let codigoBarras = CodigoPrincipalTxt.text!
                let precioVenta = precioVentaTxt.text!
                if(!DB.insertarEnDB(tabla: DB.productos, columnas: "(nombre,precioCompra,precioVenta,codigoBarras,esCaja)", valores: "('\(nombreCaja)',\(precio),\(precioVenta),'\(codigoBarras)','si')") && !DB.insertarEnDB(tabla: DB.cajas, columnas: "(idCaja,idProducto,cantidadEnCaja)", valores: "(\(idCaja),\(idProducto),\(cantidadEnCaja))")){
                    //Insertar Productos
                    print("Error al insertar Producto")
                }else{
                    ///
                    ///Desea Registrar Otra caja o ir a cajas o nada
                    ///
                    let alert = UIAlertController(title: "Éxito", message: "La caja se ha registrado correctamente.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ir a Ventas", style: .default, handler: { action in
                        self.irAPantallaCon(titulo: "Ventas")
                    }))
                    alert.addAction(UIAlertAction(title: "Registrar otra caja", style: .default, handler: {action in
                        self.CodigoPrincipalTxt.text = ""
                        self.nombreTxt.text = ""
                        self.piezasTxt.text = ""
                        self.precioTxt.text = ""
                        self.CodigoSecundarioTxt.text = ""
                        self.precioVentaTxt.text = ""
                    
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                ///
                ///El producto no existe, ir a registro de productos
                ///
                
                let alert = UIAlertController(title: GlobalVariables.error, message: "El producto que desea agregar para esta caja no existe, debe registrarlo primero", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ir a registro de productos", style: .default, handler: { action in
                    self.irAPantallaCon(titulo: "Registro de Productos")
                }))
                alert.addAction(UIAlertAction(title: "Lo corregiré", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    
        }else{
            let alert = UIAlertController(title: GlobalVariables.error, message: "La caja que intenta registrar ya esta registrada, para agregar stock, ir a compras", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ir a compras", style: .default, handler: { action in
                self.irAPantallaCon(titulo: "Compras")
            }))
            alert.addAction(UIAlertAction(title: "Lo corregiré", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
    
    
    @IBAction func registrarPressed(_ sender: Any) {
        let tupla = validaCampos()
        if(tupla.valida){
            insertarProducto()
        }else{
            self.present(DB.alertaDefault(titulo: "Error", texto: tupla.errorLog), animated: true, completion: nil)
            
        }
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

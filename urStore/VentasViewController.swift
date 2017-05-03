//
//  VentasViewController.swift
//  urStore
//
//  Created by Abraham Soto on 30/04/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class VentasViewController: UIViewController,BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate,BarcodeScannerDismissalDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var totalTxt: UITextField!
    
    @IBAction func pressGuardarVenta(_ sender: Any) {
        //Modificación inventario
        //Recorremos los productos
        var banderaExito = true
        for arr in Arreglo {
            //Vemos si existe el producto
            if(existeProducto(id: arr[0])){
                //Update
                // checamos si es caja
                if(arr[4] == "no"){
                    //Si no es caja no hay problam
                    if(!quitarStock(id: arr[0], cantidadNueva: arr[5])){
                        banderaExito = false
                    }
                }else{
                    ///Implementar como caja y checar dos opciones, el producto existe o no
                    let datosCaja = DB.selectFrom(table: DB.cajas, columnas: "idProducto,cantidadEnCaja",whereClause: "idCaja = \(arr[0])")
                    //Producto si existe
                    if(existeProducto(id: datosCaja[0][0])){
                        if(!quitarStock(id: arr[0], cantidadNueva: arr[5]) && !quitarStock(id: datosCaja[0][0], cantidadNueva: datosCaja[0][1])){
                            banderaExito = false
                        }
                    }else{
                        //El producto no tiene Stock ir a compras
                        let alert = UIAlertController(title: "Error", message: "El producto no tiene stock.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ir a compras", style: .default, handler: { (action) in
                            self.irAPantallaCon(titulo: "Compras")
                        }))
                        alert.addAction(UIAlertAction(title: "Intentar de nuevo", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    
                }
            }else{
                //El producto no tiene stock, ir a compras
                
            }
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        //Modificacion historial
        if !DB.insertarEnDB(tabla: DB.historial, columnas: "(fecha,tipo,total,idTienda)" , valores: "('\(result)','Compra',\(totalTxt.text!),\(GlobalVariables.idTienda))"){
            banderaExito = false
        }
        //Modificación historial producto
        let idHistorial = DB.selectFrom(table: DB.historial, columnas: "MAX(idTransaccion)")[0][0]
        
        for arr in Arreglo {
            if !DB.insertarEnDB(tabla: DB.historialProductos, columnas: "(idTransaccion,idProducto,cantidad)", valores: "(\(idHistorial),\(arr[0]),\(arr[5]))"){
                banderaExito = false
            }
        }
        
        if(banderaExito){
            //La compra ha sigo guardada con Exito
            let alert = UIAlertController(title: "Éxito", message: "La compra se ha guardado correctamente", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Realizar otra compra", style: .default, handler: { (action) in
                self.totalTxt.text = "0.0"
                self.Arreglo = []
                self.tabla.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            print("Error en la venta")
        }
    }
    
    func existeProducto(id : String)->Bool{
        return DB.selectFrom(table: DB.inventario, columnas: "*", whereClause: "WHERE idProducto = \(id)").count > 0
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
    
    
    
    func quitarStock(id:String,cantidadNueva:String)->Bool{
        let cantidadActual = DB.selectFrom(table: DB.inventario, columnas: "cantidad", whereClause: "WHERE idProducto = \(id) AND idTienda = \(GlobalVariables.idTienda)")[0][0]
        
        if DB.update(tabla: DB.inventario, nuevosValores: "cantidad = \(Int(cantidadActual)! - Int(cantidadNueva)!)", whereClause: "WHERE idProducto = \(id) AND idTienda = \(GlobalVariables.idTienda)"){
            return true
        }
        return false
    }

    var scan = BarcodeScannerController()
    var Arreglo:[[String]] = []
    let DB:DataBase = DataBase()

    @IBAction func presHelp(_ sender: Any) {
        self.present(DB.alertaDefault(titulo: "Ayuda", texto: "Con el símbolo de ➕ agrega productos y procesa la compra."), animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalVariables.siEsCompraEsTrue = false
        if(DB.inicializar()){
            print("Éxito con la base en ventas")
        }
        tabla.delegate = self
        tabla.dataSource = self
        tabla.allowsMultipleSelection = false
        tabla.allowsSelection = false
        totalTxt.text = "\(Double(0))"
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func tapEnPantalla(){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabla.reloadData()
        actualizarTotal()
    }
    func actualizarTotal(){
        var acu = 0.00
        for arr in Arreglo {
            acu = acu + (Double(arr[4])! * Double(arr[2])!)
        }
        
        totalTxt.text = "\(acu)"
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
        print("Error al capturar código")
    }
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        scan.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            Arreglo.remove(at: indexPath.row)
            tabla.deleteRows(at: [indexPath], with: .fade)
        }
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

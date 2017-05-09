//
//  VentasViewController.swift
//  urStore
//
//  Created by Abraham Soto on 30/04/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class VentasViewController: UIViewController,BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate,BarcodeScannerDismissalDelegate,UITableViewDelegate,UITableViewDataSource {
    var ArregloQuerysInsertar:[String] = []
    var ArregloQuerysStocks:[String] = []
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var totalTxt: UITextField!
    
    
    
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
    

    var scan = BarcodeScannerController()
    var Arreglo:[[String]] = []
    let DB:DataBase = DataBase()

    @IBAction func presHelp(_ sender: Any) {
        self.present(DB.alertaDefault(titulo: "Ayuda", texto: "Con el símbolo de ➕ agrega productos y procesa el pago."), animated: true, completion: nil)
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
    
    @IBAction func pressHelp(_ sender: Any) {
        self.present(DB.alertaDefault(titulo: "Ayuda", texto: "Con el símbolo de ➕ agrega productos y procesa la venta."), animated: true, completion: nil)
    }
    @IBAction func pressProcesarPagp(_ sender: Any) {
        if(!Arreglo.isEmpty){
            for arr in Arreglo {
                //Vemos si existe el producto
                //Checamos si es caja
                let cantidadActual = DB.selectFrom(table: DB.inventario, columnas: "cantidad", whereClause: "WHERE idProducto = \(arr[0]) AND idTienda = \(GlobalVariables.idTienda)")[0][0]
                if(arr[4] == "si"){
                    //Es caja, se debe quitar cantidad de stock, y cantidadEnCaja de stock de producto
                    
                    
                    let QueryStockCaja = "UPDATE \(DB.inventario) SET cantidad = \(Int(cantidadActual)! - Int(arr[5])!) WHERE idProducto = \(arr[0]) AND idTienda = \(GlobalVariables.idTienda)"
                    var cajaData = DB.selectFrom(table: DB.cajas, columnas: "idProducto,cantidadEnCaja",whereClause: "WHERE idCaja = \(arr[0])")
                    
                    let cantidadActualProducto = DB.selectFrom(table: DB.inventario, columnas: "cantidad",whereClause: "WHERE idProducto = \(cajaData[0][0])")[0][0]
                    
                    let QueryStockProd = "UPDATE \(DB.inventario) SET cantidad = \(Int(cantidadActualProducto)! - Int(cajaData[0][1])!) WHERE idProducto = \(cajaData[0][0]) AND idTienda = \(GlobalVariables.idTienda)"
                    
                    ArregloQuerysStocks.append(QueryStockCaja)
                    ArregloQuerysStocks.append(QueryStockProd)
                    //Query para quitar producto
                }else{
                    //Es producto, se quita cantidad de stock
                    let QueryStockProd = "UPDATE \(DB.inventario) SET cantidad = \(Int(cantidadActual)! - Int(arr[5])!) WHERE idProducto = \(arr[0]) AND idTienda = \(GlobalVariables.idTienda)"
                    ArregloQuerysStocks.append(QueryStockProd)
                }
            }
            
            
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let result = formatter.string(from: date)
            //Modificacion historial
            /*if !DB.insertarEnDB(tabla: DB.historial, columnas: "(fecha,tipo,total,idTienda)" , valores: "('\(result)','Compra',\(totalTxt.text!),\(GlobalVariables.idTienda))"){
             banderaExito = false
             }
             //Modificación historial producto
             let idHistorial = DB.selectFrom(table: DB.historial, columnas: "MAX(idTransaccion)")[0][0]
             */
            
            ArregloQuerysInsertar.append("INSERT INTO \(DB.historial) (fecha,tipo,total,idTienda) VALUES ('\(result)','Venta',\(totalTxt.text!),\(GlobalVariables.idTienda))")
            let idHistorial = DB.selectFrom(table: DB.historial, columnas: "MAX(idTransaccion)")[0][0]
            
            for arr in Arreglo {
                ArregloQuerysInsertar.append("INSERT INTO \(DB.historialProductos) (idTransaccion,idProducto,cantidad) VALUES (\(idHistorial),\(arr[0]),\(arr[5]))")
            }
            let procesarComprar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "procesarPagoSB") as! ProcesarPagoViewController
            
            procesarComprar.ArregloInserts = ArregloQuerysInsertar
            procesarComprar.ArregloUpdates = ArregloQuerysStocks
            procesarComprar.total = self.totalTxt.text!
            
            
            /*let procesarCompra = ProcesarPagoViewController(total: self.totalTxt.text!, aup: ArregloQuerysStocks, ain: ArregloQuerysInsertar)*/
            self.navigationController?.pushViewController(procesarComprar, animated: true)
        }else{
            self.present(DB.alertaDefault(titulo: GlobalVariables.error, texto: "Para poder proceder con el pago debe haber al menos un producto en la venta."), animated: true, completion: nil)
        }
    }
    
    func tapEnPantalla(){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabla.reloadData()
        ArregloQuerysInsertar.removeAll()
        ArregloQuerysStocks.removeAll()
        actualizarTotal()
        
    }
    func actualizarTotal(){
        var acu = 0.00
        for arr in Arreglo {
            acu = acu + (Double(arr[5])! * Double(arr[2])!)
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
        let total = Double(Arreglo[indexPath.row][5])! * Double(Arreglo[indexPath.row][2])!
        let cell = CeldaProForProductTables(nombre: Arreglo[indexPath.row][1], cantidad: Arreglo[indexPath.row][5], precio: "\(total)")
        
        return cell
    }
  
    
    @IBAction func pressCameras(_ sender: Any) {
        scan.reset()
        scan.errorDelegate = self
        scan.dismissalDelegate = self
        scan.codeDelegate = self
        present(scan, animated: true,completion:nil)
    }
    
    //////////Protocolos
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        scan.dismiss(animated: true, completion: nil)
        let id = DB.selectFrom(table: DB.productos, columnas: "id",whereClause: "WHERE codigoBarras = '\(code)'")[0][0]
        
        if(Int(DB.selectFrom(table: DB.inventario, columnas: "cantidad",whereClause: "WHERE idProducto = \(id)")[0][0])!>0){
            var producto = DB.selectFrom(table: DB.productos, columnas: "id,nombre,precioVenta,codigoBarras,esCaja",whereClause: "WHERE codigoBarras ='\(code)'")
            
            producto[0].append("1")
            print(producto)
            agregarACompra(producto: producto[0])
        }else{
            let alert = UIAlertController(title: "Error", message: "El producto no tiene stock.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ir a Compras", style: .default, handler: { (action) in
                self.irAPantallaCon(titulo: "Compras")
            }))
            alert.addAction(UIAlertAction(title: "Intentar otra vez", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
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
            actualizarTotal()
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

//
//  AgregarACompraViewController.swift
//  urStore
//
//  Created by Abraham Soto on 26/04/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class AgregarACompraViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let DB:DataBase = DataBase()
    var scan = BarcodeScannerController()
    
    @IBOutlet weak var codigoTxt: UITextField!
    @IBOutlet weak var tablaProductos: UITableView!
    @IBOutlet weak var cantidadTxt: UITextField!
    
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
        // Do any additional setup after loading the view.
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

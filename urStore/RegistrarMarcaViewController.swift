//
//  RegistrarMarcaViewController.swift
//  urStore
//
//  Created by Abraham Soto on 25/04/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class RegistrarMarcaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nombreTxt: UITextField!
    @IBOutlet weak var tablaProveedores: UITableView!
    var arregloProveedores:[[String]] = []
    let DB: DataBase = DataBase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(GlobalVariables.idTienda)
        DB.inicializar()
        tablaProveedores.delegate = self
        tablaProveedores.dataSource = self
        tablaProveedores.allowsSelection = true
        tablaProveedores.allowsMultipleSelection = false
        arregloProveedores = DB.selectFrom(table: DB.proveedores, columnas: "idProveedor,nombreProveedor", whereClause: "where idTienda = \(GlobalVariables.idTienda)")
        
        //print(arregloProveedores)
        tablaProveedores.reloadData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressRegistrarMarca(_ sender: Any) {
        let tupla = validaCampos()
        if(tupla.valida){
            insertarMarca()
        }else{
            self.present(DB.alertaDefault(titulo: "Error", texto: tupla.errorLog), animated: true, completion: nil)
            
        }
    }
    
    func insertarMarca(){
        if(!DB.insertarEnDB(tabla: DB.marcas, columnas: "(nombreMarca,idProveedor)", valores: "('\(nombreTxt.text!)','\(arregloProveedores[(tablaProveedores.indexPathForSelectedRow?.row)!][0])')")){
            //print("Error al insertar marca")
        }else{
            ///
            ///Desea Registrar Otra marca o ir a productos o nada
            ///

        }
    }
    
    func validaCampos()->(valida:Bool,errorLog:String){
        var errorLog = ""
        if(nombreTxt.text == ""){
            errorLog = "\(errorLog)Nombre no puede estar vacio\n"
        }
        if(tablaProveedores.indexPathForSelectedRow == nil){
            errorLog = "\(errorLog)Debe seleccionar un proveedor\n"
        }
        
        
        return (errorLog == "",errorLog)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloProveedores.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "1")
        cell.textLabel?.text = arregloProveedores[indexPath.row][1]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
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

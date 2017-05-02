//
//  RegistrarProveedorViewController.swift
//  urStore
//
//  Created by Abraham Soto on 25/04/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class RegistrarProveedorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var nombreTxt: UITextField!
    @IBOutlet weak var frecuenciaTxt: UITextField!
    @IBOutlet weak var frecuenciaSelector: UIPickerView!
    let arregloFrecuencia = [["1","2","3","4","5","6","7","8","9"],["Días","Semanas","Meses","Años"]]
    let DB:DataBase = DataBase()
    override func viewDidLoad() {
        super.viewDidLoad()
        if DB.inicializar(){
            print("Éxito con DB en registrar proveedores")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        self.view.addGestureRecognizer(tap)
        frecuenciaTxt.text = "\(arregloFrecuencia[0][frecuenciaSelector.selectedRow(inComponent: 0)]) \(arregloFrecuencia[1][frecuenciaSelector.selectedRow(inComponent: 1)])"
    }
    
    func tapEnPantalla(){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registrarProveedor(_ sender: UIButton) {
        let tupla = validaCampos()
        if(tupla.valida){
            insertarProveedor()
        }else{
            self.present(DB.alertaDefault(titulo: "Error", texto: tupla.errorLog), animated: true, completion: nil)
            
        }
    }
    
    func insertarProveedor(){
        if(!DB.insertarEnDB(tabla: DB.proveedores, columnas: "(nombreProveedor,frecuencia,idTienda)", valores: "('\(nombreTxt.text!)','\(frecuenciaTxt.text!)','\(GlobalVariables.idTienda)')")){
            //print("Error al insertar Proveedor")
        }else{
            ///
            ///Desea Registrar Otro proveedor o ir a marcas o nada
            ///
            
            let alert = UIAlertController(title: "Éxito", message: "El proveedor se ha registrado con éxito.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ir a Marcas", style: .default, handler: { action in
                self.irAPantallaCon(titulo: "Registro de Marcas")
            }))
            alert.addAction(UIAlertAction(title: "Registrar otro proveedor", style: .default, handler: { action in
                self.nombreTxt.text = ""
                self.frecuenciaTxt.text = ""
                self.frecuenciaSelector.selectRow(0, inComponent: 0, animated: true)
                self.frecuenciaSelector.selectRow(0, inComponent: 1, animated: true)
                self.frecuenciaTxt.text = "\(self.arregloFrecuencia[0][self.frecuenciaSelector.selectedRow(inComponent: 0)]) \(self.arregloFrecuencia[1][self.frecuenciaSelector.selectedRow(inComponent: 1)])"
            }))
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
    
    func validaCampos()->(valida:Bool,errorLog:String){
        var errorLog = ""
        if(nombreTxt.text == ""){
            errorLog = "\(errorLog)Nombre no puede estar vacío\n"
        }
        
        
        return (errorLog == "",errorLog)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arregloFrecuencia[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arregloFrecuencia[component][row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        frecuenciaTxt.text = "\(arregloFrecuencia[0][frecuenciaSelector.selectedRow(inComponent: 0)]) \(arregloFrecuencia[1][frecuenciaSelector.selectedRow(inComponent: 1)])"
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

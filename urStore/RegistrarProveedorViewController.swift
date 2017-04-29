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
        DB.inicializar()
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
        }
    }
    
    func validaCampos()->(valida:Bool,errorLog:String){
        var errorLog = ""
        if(nombreTxt.text == ""){
            errorLog = "\(errorLog)Nombre no puede estar vacio\n"
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

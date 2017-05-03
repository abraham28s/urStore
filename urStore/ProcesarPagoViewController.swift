//
//  ProcesarPagoViewController.swift
//  urStore
//
//  Created by Abraham Soto on 03/05/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class ProcesarPagoViewController: UIViewController {

    @IBOutlet weak var cambioTxt: UITextField!
    @IBOutlet weak var totalTxt: UITextField!
    var ArregloUpdates:[String] = []
    var ArregloInserts:[String] = []
    let DB:DataBase = DataBase()
    var total="0.00"
    override func viewDidLoad() {
        super.viewDidLoad()
        if DB.inicializar(){
            print("Exito con base en procesar pago")
            
        }
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        // Do any additional setup after loading the view.
    }
    
    
    
    func tapEnPantalla(){
        self.view.endEditing(true)
    }

    @IBAction func dineroRecibidoChange(_ sender: UITextField) {
        if sender.text != ""{
            if(Double(totalTxt.text!)!<=Double(sender.text!)!){
                cambioTxt.text = "\(Double(sender.text!)!-Double(totalTxt.text!)!)"
            }else{
                cambioTxt.text = ""
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        totalTxt.text! = total
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressGuardarCompra(_ sender: Any) {
        var banderaExito = true
        print("YAANDOACA")
        print(ArregloUpdates)
        print(ArregloInserts)
        for arr in ArregloUpdates{
            if !DB.updateRawQuery(query: arr){
                banderaExito = false
            }
        }
        for arr in ArregloInserts{
            if !DB.insertarRawQuery(query: arr){
                banderaExito = false
            }
        }
        
        if(banderaExito){
            let alert = UIAlertController(title: "Éxito", message: "La venta se ha guardado correctamente", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Realizar otra venta", style: .default, handler: { (action) in
                self.irAPantallaCon(titulo: "Ventas")
            }))
                
            alert.addAction(UIAlertAction(title: "Ir a inventario", style: .default, handler: { (action) in
                self.irAPantallaCon(titulo: "Inventario")
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                //self.irAPantallaCon(titulo: "Inventario")
                self.irAPantallaCon(titulo: "Ventas")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func irAPantallaCon(titulo:String)->Void{
        let padre = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as! ViewController
        //let padre = padreE.parent as! ViewController
        
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
        self.navigationController?.popViewController(animated: true)
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

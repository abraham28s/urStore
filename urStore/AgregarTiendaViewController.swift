//
//  AgregarTiendaViewController.swift
//  urStore
//
//  Created by Abraham Soto on 24/04/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class AgregarTiendaViewController: UIViewController {

    @IBOutlet weak var nombreTxt: UITextField!
    let DB = DataBase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    func tapEnPantalla(){
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressAgregarBtn(_ sender: Any, forEvent event: UIEvent) {
        if(nombreTxt.text != ""){
            if(DB.inicializar()){
                if(DB.insertarEnDB(tabla: "Tiendas", columnas: "(nombreTienda)", valores: "('\(nombreTxt.text!)')")){
                    let alert = UIAlertController(title: "Éxito", message: "La tienda se registró con éxito.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alerr) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }else{
                    print("Error al insertar nueva tienda");
                }
            }
        }else{
            
            self.present(DB.alertaDefault(titulo: "Error", texto: "El nombre no puede estar vacío."), animated: true, completion: nil)
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

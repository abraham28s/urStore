//
//  InventarioViewController.swift
//  urStore
//
//  Created by Abraham Soto on 14/02/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class InventarioViewController:  UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var TFCantidad: UITextField!
    @IBOutlet weak var StepperCantidad: UIStepper!
    @IBOutlet weak var TablaProductos: UITableView!
    let ArregloProductos = [[1,"Coca-Cola",4,32.00],[2,"Pepsi",2,16.00],[3,"Fanta",6,48.00]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TablaProductos.delegate = self
        TablaProductos.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func CambiaValorStepper(_ sender: Any) {
        TFCantidad.text = String(Int((sender as! UIStepper).value))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArregloProductos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CeldaProForProductTables(clave: String(describing: ArregloProductos[indexPath.row][0]), descripcion: ArregloProductos[indexPath.row][1] as! String, cantidad: String(describing: ArregloProductos[indexPath.row][2]), total: String(describing: ArregloProductos[indexPath.row][3]))
        
        return cell
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

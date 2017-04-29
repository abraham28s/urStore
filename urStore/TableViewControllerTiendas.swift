//
//  TableViewController.swift
//  urStore
//
//  Created by Abraham Soto on 13/02/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    @IBOutlet var tablaTiendas: UITableView!
    
    var arregloTiendas:[[String]] = []
    let DB = DataBase()
    var ind = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(arregloTiendas.count)
        
        if(DB.inicializar()){
            print("Exito con la base")
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        arregloTiendas = DB.selectFrom(table: "Tiendas", columnas: "idTienda,nombreTienda")
        //print(arregloTiendas)
        tablaTiendas.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arregloTiendas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        //print(indexPath.row)
        cell.textLabel?.text = arregloTiendas[indexPath.row][1]

        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ind = indexPath.row
        GlobalVariables.idTienda = arregloTiendas[indexPath.row][0]
        print(GlobalVariables.idTienda)
        performSegue(withIdentifier: "entrarATienda", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "entrarATienda"){
            if let vc = segue.destination as? ViewController{
                vc.titulo = arregloTiendas[ind][1]
            }
        }
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

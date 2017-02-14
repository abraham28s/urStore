//
//  BalanceViewController.swift
//  urStore
//
//  Created by Abraham Soto on 14/02/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TablaSalidas: UITableView!
    
    @IBOutlet weak var TotalTF: UITextField!
    
    @IBOutlet weak var TablaEntradas: UITableView!
    var ArregloEntradas = [39.23,46.03,52.89]
    var ArregloSalidas = [34.23,45.03,56.89,34.90,13.98]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var total = 0.0
        for monto in ArregloEntradas {
            total += monto
        }
        
        for monto in ArregloSalidas {
            total -= monto
        }
        
        TotalTF?.text = String(total)
        
        if(total < 0){
            TotalTF?.textColor = UIColor.red
        }else if (total > 0){
            TotalTF?.textColor = UIColor.green
        }else if (total == 0){
            TotalTF?.textColor = UIColor.black
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch tableView {
        case TablaSalidas:
            return 1
        case TablaEntradas:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch tableView {
        case TablaSalidas:
            return 5
        case TablaEntradas:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        switch tableView {
        case TablaSalidas:
            cell.textLabel?.text = String(ArregloSalidas[indexPath.row])
            cell.textLabel?.textColor = UIColor.red
        case TablaEntradas:
            cell.textLabel?.text = String(ArregloEntradas[indexPath.row])
            cell.textLabel?.textColor = UIColor.green
        default:
            return cell
            
        }
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

//
//  RegistroViewController.swift
//  urStore
//
//  Created by Abraham Soto on 14/02/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var RegistroProductosTable: UITableView!
    
    var Arreglo = ["Coca-Cola","Pepsi","Fanta"]
    override func viewDidLoad() {
        super.viewDidLoad()
        RegistroProductosTable.delegate = self
        RegistroProductosTable.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Arreglo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        
        cell.textLabel?.text = Arreglo[indexPath.row]
        
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

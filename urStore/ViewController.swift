//
//  ViewController.swift
//  urStore
//
//  Created by Abraham Soto on 07/02/17.
//  Copyright © 2017 Abraham. All rights reserved.
//  Copyright © 2017 Josep Romagosa. All rights reserved.
//  Copyright © 2017 Luis Richardo Moon. All rights reserved.
//  Copyright © 2017 Javier Esponda. All rights reserved.

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var menuLateral:UIView? = UIView()
    var gestoMostrar:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    var gestoOcultar:UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    var tablaMenu:UITableView = UITableView()
    @IBOutlet weak var botonMenu: UIButton!
    var menuMostrado = false
    var currentViewController: UIViewController?
    @IBOutlet weak var contenedor: UIView!
    
    var tapPantalla = UITapGestureRecognizer()
    
    let ArregloSecciones = ["Movimientos","Información","Finanzas","Más"]
    let ArregloColumnas = [["Ventas","Compras"],["Inventario","Compras Sugeridas"],["Balance"],["Proveedores","Registro de Productos","Ajustes de tienda"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        menuLateral = UIView(frame: CGRect(x: -300, y: 44, width: 300, height: view.frame.height-44))
        menuLateral?.backgroundColor = UIColor.black
        menuLateral?.isHidden = true
        
        tablaMenu = UITableView(frame: CGRect(x: 50, y: 0, width: 300, height: (self.menuLateral?.frame.height)!) , style: UITableViewStyle.grouped)
        tablaMenu.delegate = self
        tablaMenu.dataSource = self
        menuLateral?.addSubview(tablaMenu)
        view.addSubview(menuLateral!)
        
        tapPantalla = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        
        
        gestoMostrar = UISwipeGestureRecognizer(target: self, action: #selector(mostrarMenuLateral))
        gestoMostrar.direction = .right
        view.addGestureRecognizer(gestoMostrar)
        
        gestoOcultar = UISwipeGestureRecognizer(target: self, action: #selector(ocultarMenuLateral))
        gestoOcultar.direction = .left
        view.addGestureRecognizer(gestoOcultar)
        self.view.isExclusiveTouch = false
        contenedor.isUserInteractionEnabled = true
        
        /*self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ventasSB")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.currentViewController?.view.isUserInteractionEnabled = true
        self.addSubview(subView: self.currentViewController!.view, toView: self.contenedor)*/
        self.currentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ventasSB") as UIViewController
        self.displayContentController(content: self.currentViewController!)
        self.navigationItem.title = "Ventas"
        
        super.viewDidLoad()
        
    }
    
    func tapEnPantalla(){
        if menuMostrado{
            ocultarMenuLateral()
        }else{
            self.view.endEditing(true)
        }
    }
    
    func displayContentController(content: UIViewController) {
        
        addChildViewController(content)
        contenedor.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    
    func hideContentController(content: UIViewController) {
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
    
    func mostrarMenuLateral(){
        self.view.endEditing(true)
        if !menuMostrado {
            menuMostrado = true
            menuLateral?.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: UIViewAnimationOptions.curveLinear,
                       animations:{
                        self.menuLateral?.frame = CGRect(x: -50, y: 44, width: 300, height: self.view.frame.height-44)
                        self.botonMenu.frame = CGRect(x: self.botonMenu.frame.minX + 300, y: self.botonMenu.frame.minY, width: self.botonMenu.frame.width, height: self.botonMenu.frame.height)
            }, completion: nil)
        }
        
    }
    
    func ocultarMenuLateral(){
        if menuMostrado {
            menuMostrado = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: UIViewAnimationOptions.curveLinear, animations:{
                self.menuLateral?.frame = CGRect(x: -350, y: 44, width: 300, height: self.view.frame.height-44)
                self.botonMenu.frame = CGRect(x: self.botonMenu.frame.minX - 300, y: self.botonMenu.frame.minY, width: self.botonMenu.frame.width, height: self.botonMenu.frame.height)
            }, completion: nil)
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func mostrarMenu(_ sender: Any) {
        if((sender as! UIButton).frame.maxX>150){
            ocultarMenuLateral()
        }else{
            mostrarMenuLateral()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ArregloColumnas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArregloColumnas[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
            case 0:
                cambiarHijo(identif: "ventasSB")
                self.navigationItem.title = "Ventas"
            case 1:
                cambiarHijo(identif: "ingresosSB")
                self.navigationItem.title = "Compras"
            default:
                print("nothing")
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                cambiarHijo(identif: "inventarioSB")
                self.navigationItem.title = "Inventario"
            case 1:
                cambiarHijo(identif: "comprasSugeridasSB")
                self.navigationItem.title = "Compras Sugeridas"
            default:
                 print("nothing")
            }
        case 2:
            switch indexPath.row {
            case 0:
                cambiarHijo(identif: "balanceSB")
                self.navigationItem.title = "Balance"
            default:
                print("nothing")
            }
        case 3:
            print("hola")
        default:
            print("hola")
        }
        
        self.ocultarMenuLateral()
        
    }
    
    func cambiarHijo(identif: String){
        hideContentController(content: self.currentViewController!)
        self.currentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identif) as UIViewController
        self.displayContentController(content: self.currentViewController!)
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var celda = UITableViewCell(style: .default, reuseIdentifier: "cell")
        celda.textLabel?.text = ArregloColumnas[indexPath.section][indexPath.row]
        return celda
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ArregloSecciones[section]
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.menuLateral?.isHidden = true
    }

}


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
        
        
        gestoMostrar = UISwipeGestureRecognizer(target: self, action: #selector(mostrarMenuLateral))
        gestoMostrar.direction = .right
        view.addGestureRecognizer(gestoMostrar)
        
        gestoOcultar = UISwipeGestureRecognizer(target: self, action: #selector(ocultarMenuLateral))
        gestoOcultar.direction = .left
        view.addGestureRecognizer(gestoOcultar)
        
    }
    
    func mostrarMenuLateral(){
        if !menuMostrado {
            menuMostrado = true
            menuLateral?.isHidden = false
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveLinear,
                       animations:{
                        self.menuLateral?.frame = CGRect(x: -50, y: 44, width: 300, height: self.view.frame.height-44)
                        self.botonMenu.frame = CGRect(x: self.botonMenu.frame.minX + 300, y: self.botonMenu.frame.minY, width: self.botonMenu.frame.width, height: self.botonMenu.frame.height)
            }, completion: nil)
        }
        
    }
    
    func ocultarMenuLateral(){
        if menuMostrado {
            menuMostrado = false
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveLinear, animations:{
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
                self.currentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ventasSB") as UIViewController
            default:
                print("hola")
            }
            
        case 1:
            print("hola")
        case 2:
            print("hola")
        case 3:
            print("hola")
        default:
            print("hola")
        }
        
        self.ocultarMenuLateral()
        
        /*self.addChildViewController(nextView)
        nextView.view.frame = CGRect(x: 0, y: 109, width: nextView.view.frame.width, height: nextView.view.frame.height)
        nextView.didMove(toParentViewController: self)*/
        
        
        /*self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.contenedor)*/
        
        let newViewController = self.currentViewController
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
        self.currentViewController = newViewController
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.contenedor!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParentViewController()
                                    newViewController.didMove(toParentViewController: self)
        })
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        
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


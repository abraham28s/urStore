//
//  DataBase.swift
//  urStore
//
//  Created by Abraham Soto on 14/03/17.
//  Copyright © 2017 Abraham. All rights reserved.
//


//Todo: terminar compras como caja, pantalla pago ventas, afectacion por ventas y detalles esteticos.


import Foundation
import UIKit


class DataBase {
    
    let tiendas = "Tiendas"
    let productos = "ProductosCajas"
    let cajas = "Cajas"
    let marcas = "Marcas"
    let inventario = "Inventario"
    let historial = "Historial"
    let historialProductos = "HistorialProductos"
    let proveedores = "Proveedores"
    
    var basesDatos: OpaquePointer? = nil
    
    func inicializar() -> Bool{
        if abrirBaseDatos() {
            if(crearTablas()){
                
                return true
            }else{
                return false
            }
        } else {
            return false
        }
    }
    
    func crearTablas()->Bool{
        let tblTiendas = crearTabla(nombreTabla: "Tiendas", campos: ["idTienda INTEGER PRIMARY KEY AUTOINCREMENT", "nombreTienda TEXT"])
        
        
        let tblProductos = crearTabla(nombreTabla: "ProductosCajas", campos: ["id INTEGER PRIMARY KEY AUTOINCREMENT", "nombre TEXT", "precioCompra DECIMAL","precioVenta Decimal","codigoBarras TEXT","unidad TEXT", "idMarca INTEGER","esCaja TEXT"])
        
        
        
        let tblCajas = crearTabla(nombreTabla: "Cajas", campos: ["idCaja INTEGER", "idProducto INTEGER", "cantidadEnCaja INTEGER"])
        
        let tblMarcas = crearTabla(nombreTabla: "Marcas", campos: ["idMarca INTEGER PRIMARY KEY AUTOINCREMENT", "nombreMarca TEXT","idProveedor INTEGER"])
        
        let tblInventario = crearTabla(nombreTabla: "Inventario", campos: ["idInv INTEGER PRIMARY KEY AUTOINCREMENT", "idProducto INTEGER", "cantidad INTEGER", "idTienda INTEGER"])
        
        let tblHistorial = crearTabla(nombreTabla: "Historial", campos: ["idTransaccion INTEGER PRIMARY KEY AUTOINCREMENT", "fecha DATE","tipo TEXT","total DECIMAL","idTienda INTEGER"])
        
        let tblHistorialProductos = crearTabla(nombreTabla: "HistorialProductos", campos: ["idTransaccion INTEGER", "idProducto INTEGER", "cantidad INTEGER"])
        
        let tblProveedores = crearTabla(nombreTabla: "Proveedores", campos: ["idProveedor INTEGER PRIMARY KEY AUTOINCREMENT", "nombreProveedor TEXT","frecuencia TEXT","idTienda INTEGER"])
        
        return tblTiendas && tblProductos && tblMarcas && tblInventario && tblHistorial && tblHistorialProductos && tblProveedores && tblCajas
            
        
    }
    
    func crearTabla(nombreTabla: String, campos: [String]) -> Bool {
        let sqlCreaTabla = "CREATE TABLE IF NOT EXISTS \(nombreTabla)" + "(\(campos.joined(separator: ", ")))"
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(basesDatos, sqlCreaTabla, nil, nil, &error) == SQLITE_OK {
            return true
        } else {
            sqlite3_close(basesDatos)
            let msg = String.init(cString: error!)
            print("Error: \(msg)")
            return false
        }
    }
    
    func abrirBaseDatos() -> Bool {
        if let path = obtenerPath("urStore.txt") {
            print("\nThe DB PATH is:\(path)\n")
            if sqlite3_open(path.absoluteString, &basesDatos) == SQLITE_OK {
                return true
            }
            // Error
            sqlite3_close(basesDatos)
        }
        return false
    }
    
    func obtenerPath(_	salida:	String)	->	URL?	{
        if let path =	FileManager.default.urls(for:.documentDirectory,	in:	.userDomainMask).first {
            return path.appendingPathComponent(salida)
        }
        return nil
    }
    
    func insertarEnDB(tabla: String, columnas: String, valores: String)->Bool{
        let sqlInserta = "INSERT INTO \(tabla) \(columnas) VALUES \(valores)"
        var error: UnsafeMutablePointer<Int8>? = nil
        print(sqlInserta)
        if sqlite3_exec(basesDatos, sqlInserta, nil, nil, &error) != SQLITE_OK {
            print("\nError en query insera")
            let errmsg = String(cString: sqlite3_errmsg(basesDatos))
            print("Error Desc: \(errmsg)\n")
           return false
        }
        return true
    }
    
    func selectOneColumToVector(tabla: String, columna: String, whereClause: String = "")->[String]{
        let sqlConsulta = "SELECT \(columna) FROM \(tabla) \(whereClause)"
        print(sqlConsulta)
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(basesDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            var result:[String] = []
            
            while sqlite3_step(declaracion) == SQLITE_ROW {
                result.append(String.init(cString: sqlite3_column_text(declaracion, Int32(0))))
            }
            return result
        }else{
            print("\nError en query consulta")
            let errmsg = String(cString: sqlite3_errmsg(basesDatos))
            print("Error Desc: \(errmsg)\n")
            return []
        }
    }
    
    func alertaDefault(titulo: String, texto:String) -> UIAlertController{
        let alert = UIAlertController(title: titulo, message: texto, preferredStyle: .alert)
        let alertAccion = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAccion)
        return alert
        
    }
    
    func selectFrom(table: String, columnas: String, whereClause: String = "")->[[String]]{
        let sqlConsulta = "SELECT \(columnas) FROM \(table) \(whereClause)"
        print(sqlConsulta)
        var declaracion: OpaquePointer? = nil
        if sqlite3_prepare_v2(basesDatos, sqlConsulta, -1, &declaracion, nil) == SQLITE_OK {
            let arrCol = columnas.components(separatedBy: ",")
            var result:[[String]] = []
            var i = 0
            while sqlite3_step(declaracion) == SQLITE_ROW {
                var j = 0
                result.append([])
                for _ in arrCol {
                    result[i].append(String.init(cString: sqlite3_column_text(declaracion, Int32(j))))
                    j += 1
                }
                i += 1
            }
            return result
        }else{
            print("\nError en query consulta")
            let errmsg = String(cString: sqlite3_errmsg(basesDatos))
            print("Error Desc: \(errmsg)\n")
            return []
        }
    }
    
    func update(tabla:String,nuevosValores:String,whereClause:String)->Bool{
        let sqlActualiza = "UPDATE \(tabla) SET \(nuevosValores) \(whereClause)"
        print(sqlActualiza)
        var error: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(basesDatos, sqlActualiza, nil, nil, &error) == SQLITE_OK {

            print("Exito al actualizar")
            return true
        }else{
            print("\nError en query update")
            let errmsg = String(cString: sqlite3_errmsg(basesDatos))
            print("Error Desc: \(errmsg)\n")
            return false
        }
    }
}

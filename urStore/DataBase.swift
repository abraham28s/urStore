//
//  DataBase.swift
//  urStore
//
//  Created by Abraham Soto on 14/03/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import Foundation



class DataBase {
    
    var basesDatos: OpaquePointer? = nil
    
    func inicializar() -> Bool{
        if abrirBaseDatos() {
            if( crearTabla(nombreTabla: "Productos", campos: ["ID INTEGER PRIMARY KEY AUTOINCREMENT", "NOMBRE TEXT", "PRECIO DECIMAL", "CANTIDAD INT"])){
                
                return true
            }else{
                return false
            }
        } else {
            return false
        }
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
            //print(path)
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
}

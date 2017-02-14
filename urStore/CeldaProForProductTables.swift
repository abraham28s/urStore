//
//  CeldaProForProductTables.swift
//  urStore
//
//  Created by Abraham Soto on 14/02/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class CeldaProForProductTables: UITableViewCell {
    
    init(clave: String,descripcion:String,cantidad:String,total:String){
        super.init(style: .default, reuseIdentifier: nil)
        
        let claveLABEL = UILabel(frame: CGRect(x: 0, y: 0, width: 47, height: self.frame.height))
        claveLABEL.text = clave
        self.addSubview(claveLABEL)
        
        let descripcionLABEL = UILabel(frame: CGRect(x: 47, y: 0, width: 143, height: self.frame.height))
        descripcionLABEL.text = descripcion
        self.addSubview(descripcionLABEL)
        
        let cantidadLABEL = UILabel(frame: CGRect(x: 143+47, y: 0, width: 103, height: self.frame.height))
        cantidadLABEL.text = cantidad
        self.addSubview(cantidadLABEL)
        
        let totalLABEL = UILabel(frame: CGRect(x: 143+47+103, y: 0, width: 43, height: self.frame.height))
        totalLABEL.text = total
        self.addSubview(totalLABEL)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

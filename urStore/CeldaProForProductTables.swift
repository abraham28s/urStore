//
//  CeldaProForProductTables.swift
//  urStore
//
//  Created by Abraham Soto on 14/02/17.
//  Copyright © 2017 Abraham. All rights reserved.
//

import UIKit

class CeldaProForProductTables: UITableViewCell {
    
    init(nombre:String,cantidad:String,precio:String){
        super.init(style: .default, reuseIdentifier: nil)
        
        
        
        let descripcionLABEL = UILabel(frame: CGRect(x: 5, y: 0, width: 165, height: self.frame.height))
        descripcionLABEL.text = nombre
        self.addSubview(descripcionLABEL)
        
        let cantidadLABEL = UILabel(frame: CGRect(x: 155, y: 0, width: 80, height: self.frame.height))
        cantidadLABEL.text = cantidad
        cantidadLABEL.textAlignment = .right
        self.addSubview(cantidadLABEL)
        
        let totalLABEL = UILabel(frame: CGRect(x: 155+80, y: 0, width: 80, height: self.frame.height))
        totalLABEL.text = precio
        totalLABEL.textAlignment = .right
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

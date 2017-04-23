//
//  TotalViewController.swift
//  Caue
//
//  Created by Cauê Almeida on 4/22/17.
//  Copyright © 2017 Usuário Convidado. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {
    
    var totalDolar: Double = 0
    var totalReal: Double = 0
    var dataSource: [Product] = []
    
    @IBOutlet weak var tfTotalReal: UILabel!
    @IBOutlet weak var tfTotalDolar: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reset
        totalDolar = 0
        totalReal = 0
        
        loadStates()
        
        displayValues(real: totalReal, dolar: totalDolar)
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            dataSource = try context.fetch(fetchRequest)
            
            calculateTotals(products: dataSource)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func calculateTotals(products: [Product]) {
        for item in dataSource {
            totalReal = totalReal + Double(item.totalReal)
            totalDolar = totalDolar + Double(item.totalDolar)
        }
        
        displayValues(real: totalReal, dolar: totalDolar)
    }
    
    func displayValues(real: Double, dolar: Double) {
        tfTotalReal.text = "\(real)"
        tfTotalDolar.text = "\(dolar)"
    }

}

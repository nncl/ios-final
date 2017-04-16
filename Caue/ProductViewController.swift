//
//  ProductViewController.swift
//  Caue
//
//  Created by Cauê Almeida on 4/9/17.
//  Copyright © 2017 Usuário Convidado. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    // MARK: - Variables
    var product: Product!
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    @IBOutlet weak var btAddUpdate: UIButton!
    @IBOutlet weak var tfState: UITextField!
    
    // MARK: - Functions/Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if product != nil {
            product.name = tfName.text
            product.card = swCard.isOn
            product.price = Float(tfPrice.text!)!
            
            btAddUpdate.setTitle("Atualizar", for: .normal)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if product != nil {
            if let states = product.states {
                let arr = states.allObjects
                tfState.text = arr.map({($0 as! State).name!}).joined(separator: " | ")
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! StatesViewController
        if product == nil {
            product = Product(context: context)
        }
        vc.product = product
    }
    
    // TODO Finish save
    @IBAction func doSaveProduct(_ sender: UIButton) {
        
        // Validate fields
        if (tfName.text?.isEmpty ?? true || tfPrice.text?.isEmpty ?? true) {
            doShowError(title: "Erro", message: "Todos os campos são obrigatórios")
        } else {
            
            if product == nil {product = Product(context: context)}
            product.name = tfName.text
            product.card = swCard.isOn
            product.price = Float(tfPrice.text!)!
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func doShowError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    /*
     * Action sheet
     
     let alert = UIAlertController(title: "Do something", message: "With this", preferredStyle: .actionSheet)
     alert.addAction(UIAlertAction(title: "A thing", style: .default) { action in
     // perhaps use action.title here
     })
     
     self.present(alert, animated: true)

     */
    

}

//
//  SettingsViewController.swift
//  Caue
//
//  Created by Cauê Almeida on 4/16/17.
//  Copyright © 2017 Usuário Convidado. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    var dataSource: [State] = []
    var product: Product!

    @IBOutlet weak var tfDolarPrice: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    func showAlert(type: StateAlertType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        // Add campos no alert
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do Estado US"
            
            if let name = state?.name {
                textField.text = name
            }
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
            
            if let tax = state?.tax {
                textField.text = "\(tax)"
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            // Cria um estado se não for nulo
            let state = state ?? State(context: self.context)
            state.name = alert.textFields?.first?.text
            state.tax = Double((alert.textFields?[1].text)!)!
            
            do {
                try self.context.save()
                // self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Functions
    
    @IBAction func add(_ sender: Any) {
        showAlert(type: .add, state: nil)
    }
}
